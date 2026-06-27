#!/usr/bin/env bash
# =============================================================================
# nvme_benchmark.sh
# Automated NVMe SSD data collection and benchmark report generator
# for Raspberry Pi / Compute Blade
#
# Follows the exact workflow from the Compute Blade NVMe benchmark README:
#   1. Collect device info (lsblk, lspci, fdisk, df)
#   2. Partition and format the disk (fdisk + mkfs.ext4 on whole device)
#   3. Mount at /mnt/sda1
#   4. Run Jeff Geerling's disk-benchmark.sh
#   5. Run PiBenchmarks Storage.sh
#   6. Assemble a markdown report matching the established file format
#
# Usage:
#   sudo ./nvme_benchmark.sh [OPTIONS]
#
# Options:
#   -d DEVICE    NVMe device to test (default: auto-detect, e.g. /dev/nvme0n1)
#   -o FILE      Output .md file (default: auto-named from drive model)
#   -m DIR       Mount point (default: /mnt/sda1)
#   -p ADDR      PCI address for lspci (default: auto-detect, fallback 01:00.0)
#   -b           Collect Boot Information section (nvme-cli, vcgencmd)
#   -n           Dry run: collect info only, skip format/mount/benchmarks
#   -s           Skip PiBenchmarks (Storage.sh)
#   -g           Skip Jeff Geerling (disk-benchmark.sh)
#   -h           Show this help
#
# Dependencies (must be installed):
#   lsblk, lspci, fdisk, mkfs.ext4, mount, df  (util-linux, e2fsprogs)
#   fio, iozone, hdparm                         (benchmark tools)
#   curl or wget                                (to download scripts)
#   nvme                                        (nvme-cli, for -b flag)
#   vcgencmd                                    (Raspberry Pi firmware tools, for -b flag)
# =============================================================================

set -euo pipefail

# ── Constants ─────────────────────────────────────────────────────────────────
PIBENCH_URL="https://raw.githubusercontent.com/TheRemote/PiBenchmarks/master/Storage.sh"
GEERLING_URL="https://raw.githubusercontent.com/geerlingguy/pi-cluster/master/benchmarks/disk-benchmark.sh"
PIBENCH_SCRIPT="./Storage.sh"
GEERLING_SCRIPT="./disk-benchmark.sh"

# ── Defaults ──────────────────────────────────────────────────────────────────
DEVICE=""
OUTPUT_FILE=""
MOUNTPOINT="/mnt/sda1"
PCI_ADDR=""
INCLUDE_BOOT=false
DRY_RUN=false
SKIP_PIBENCH=false
SKIP_GEERLING=false

# ── Colours ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
step()  { echo -e "\n${CYAN}──── $* ────${NC}"; }
die()   { error "$*"; exit 1; }

# ── Help ──────────────────────────────────────────────────────────────────────
usage() {
    sed -n '/^# Usage/,/^# =====/{ /^# =====/d; s/^# \{0,2\}//; p }' "$0"
    exit 0
}

# ── Argument parsing ──────────────────────────────────────────────────────────
while getopts "d:o:m:p:bnsgGh" opt; do
    case $opt in
        d) DEVICE="$OPTARG" ;;
        o) OUTPUT_FILE="$OPTARG" ;;
        m) MOUNTPOINT="$OPTARG" ;;
        p) PCI_ADDR="$OPTARG" ;;
        b) INCLUDE_BOOT=true ;;
        n) DRY_RUN=true ;;
        s) SKIP_PIBENCH=true ;;
        g) SKIP_GEERLING=true ;;
        h) usage ;;
        *) die "Unknown option. Use -h for help." ;;
    esac
done

# ── Privilege check ───────────────────────────────────────────────────────────
[[ $EUID -ne 0 ]] && die "Must run as root: sudo $0 $*"

# ── Dependency check ──────────────────────────────────────────────────────────
check_deps() {
    local missing=()
    for cmd in lsblk lspci fdisk mkfs.ext4 mount df fio iozone hdparm; do
        command -v "$cmd" &>/dev/null || missing+=("$cmd")
    done
    if $INCLUDE_BOOT; then
        for cmd in nvme vcgencmd; do
            command -v "$cmd" &>/dev/null || missing+=("$cmd")
        done
    fi
    if [[ ${#missing[@]} -gt 0 ]]; then
        die "Missing required tools: ${missing[*]}\nInstall with: sudo apt install util-linux e2fsprogs fio iozone hdparm nvme-cli"
    fi
}
$DRY_RUN || check_deps

# ── Auto-detect device ────────────────────────────────────────────────────────
step "Device detection"
if [[ -z "$DEVICE" ]]; then
    DEVICE=$(lsblk -d -o NAME,TYPE | awk '$2=="disk" && $1~/^nvme/ {print "/dev/"$1}' | head -1)
    [[ -z "$DEVICE" ]] && die "No NVMe device found. Specify one with -d /dev/nvmeXn1"
    info "Auto-detected: $DEVICE"
else
    [[ -b "$DEVICE" ]] || die "Device not found: $DEVICE"
    info "Using: $DEVICE"
fi

DEVICE_NAME=$(basename "$DEVICE")          # nvme0n1
CONTROLLER="${DEVICE_NAME%%n*}"            # nvme0

# ── Auto-detect PCI address ───────────────────────────────────────────────────
if [[ -z "$PCI_ADDR" ]]; then
    PCI_ADDR=$(readlink -f /sys/class/nvme/"$CONTROLLER" 2>/dev/null \
        | grep -oP '[0-9a-f]{4}:[0-9a-f]{2}:[0-9a-f]{2}\.[0-9a-f]+' \
        | tail -1 || true)
    if [[ -z "$PCI_ADDR" ]]; then
        warn "Could not detect PCI address; falling back to 01:00.0"
        PCI_ADDR="01:00.0"
    else
        # Strip domain prefix (0000:) to get short form e.g. 01:00.0
        PCI_ADDR=$(echo "$PCI_ADDR" | grep -oP '[0-9a-f]{2}:[0-9a-f]{2}\.[0-9a-f]+$')
        info "PCI address: $PCI_ADDR"
    fi
fi

# ── Output file name ──────────────────────────────────────────────────────────
if [[ -z "$OUTPUT_FILE" ]]; then
    DISK_MODEL=$(lsblk -d -o MODEL "$DEVICE" | tail -1 \
        | tr -s ' ' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
        | tr ' /' '__' | tr '[:upper:]' '[:lower:]')
    [[ -z "$DISK_MODEL" ]] && DISK_MODEL="nvme_unknown"
    OUTPUT_FILE="${DISK_MODEL}.md"
fi
info "Output file: $OUTPUT_FILE"

# ── Prompt prefix (matches your established style) ────────────────────────────
PROMPT="# "   # modern style used in most of your files

# ── Helper: download script if missing ───────────────────────────────────────
download_script() {
    local dest="$1" url="$2" label="$3"
    if [[ ! -f "$dest" ]]; then
        info "Downloading $label..."
        if command -v curl &>/dev/null; then
            curl -fsSL -o "$dest" "$url" || die "Download failed: $url"
        elif command -v wget &>/dev/null; then
            wget -q -O "$dest" "$url" || die "Download failed: $url"
        else
            die "curl/wget not found. Download manually: $url → $dest"
        fi
        chmod +x "$dest"
        info "$label saved to $dest"
    else
        info "$label already present: $dest"
    fi
}

# =============================================================================
# STEP 1 — Collect pre-format device info
# =============================================================================
step "Collecting device information"

LSBLK_OUT=$(lsblk | grep -E "nvme[0-9]" || true)
LSPCI_OUT=$(lspci -vvv -s "$PCI_ADDR" 2>/dev/null || echo "(lspci output unavailable)")
FDISK_OUT=$(fdisk -l "$DEVICE" 2>/dev/null || echo "(fdisk output unavailable)")

info "Device info collected."

# =============================================================================
# STEP 2 — Partition + format + mount  (skipped in dry-run mode)
# =============================================================================
if $DRY_RUN; then
    warn "Dry run: skipping format/mount/benchmarks."
    DF_OUT="(dry run — disk not formatted)"
else
    step "Preparing disk"

    # 2a. Ensure the device and mount point are free before touching the disk
    info "Checking for existing mounts on $DEVICE..."
    EXISTING_MOUNTS=$(grep -E "^${DEVICE}" /proc/mounts | awk '{print $2}' || true)
    if [[ -n "$EXISTING_MOUNTS" ]]; then
        warn "Device is currently mounted — unmounting before format..."
        while IFS= read -r mnt; do
            info "  Unmounting $mnt..."
            umount "$mnt" 2>/dev/null || umount -l "$mnt" \
                || die "Could not unmount $mnt — close any processes using it and retry."
        done <<< "$EXISTING_MOUNTS"
    fi
    if mountpoint -q "$MOUNTPOINT" 2>/dev/null; then
        warn "$MOUNTPOINT is in use by another device — unmounting..."
        umount "$MOUNTPOINT" 2>/dev/null || umount -l "$MOUNTPOINT" \
            || die "Could not unmount $MOUNTPOINT — close any processes using it and retry."
    fi

    # 2b. Format whole device as ext4 (as per README: mkfs.ext4 -F /dev/nvme0n1)
    info "Formatting $DEVICE as ext4..."
    mkfs.ext4 -J size=32 -F "$DEVICE" >/dev/null 2>&1 \
        || die "mkfs.ext4 failed on $DEVICE"

    # 2d. Mount
    info "Mounting $DEVICE at $MOUNTPOINT..."
    mkdir -p "$MOUNTPOINT"
    mount "$DEVICE" "$MOUNTPOINT" \
        || die "mount failed: $DEVICE → $MOUNTPOINT"

    DF_OUT=$(df -Th "$DEVICE" 2>/dev/null || echo "(df output unavailable)")
    info "Disk ready at $MOUNTPOINT"
fi

# =============================================================================
# STEP 3 — Jeff Geerling disk-benchmark.sh
# =============================================================================
GEERLING_RAW="(skipped)"

if ! $SKIP_GEERLING && ! $DRY_RUN; then
    step "Running Jeff Geerling disk-benchmark.sh"
    download_script "$GEERLING_SCRIPT" "$GEERLING_URL" "disk-benchmark.sh"
    # disk-benchmark.sh requires MOUNT_PATH (not a device) and checks for SUDO_USER
    GEERLING_RAW=$(MOUNT_PATH="$MOUNTPOINT" SUDO_USER="${SUDO_USER:-root}" bash "$GEERLING_SCRIPT" 2>&1 | tee /dev/tty) \
        || warn "disk-benchmark.sh exited non-zero; capturing output anyway."
    info "Geerling benchmark complete."
elif $SKIP_GEERLING; then
    warn "Skipping Geerling benchmark (-g)."
fi

# =============================================================================
# STEP 4 — PiBenchmarks Storage.sh
# =============================================================================
# Initialise all parsed values as TBD
PB_DD_WRITE="TBD"
PB_HDPARM_READ="TBD"
PB_HDPARM_CACHED="TBD"
PB_FIO_RR_IOPS="TBD"
PB_FIO_RW_IOPS="TBD"
PB_FIO_RR_KB="TBD"
PB_FIO_RW_KB="TBD"
PB_IOZ_READ="TBD"
PB_IOZ_WRITE="TBD"
PB_IOZ_RREAD="TBD"
PB_IOZ_RWRITE="TBD"
PB_SCORE="TBD"
PB_BENCH_URL_LINE="Full benchmark: *(run Storage.sh and add URL here)*"
# Storage.sh uses "4k" or "4K" depending on version; we capture and preserve as-is
PB_FIO_SIZE_TAG="4K"   # default; overridden from parsed output below

if ! $SKIP_PIBENCH && ! $DRY_RUN; then
    step "Running PiBenchmarks Storage.sh"
    download_script "$PIBENCH_SCRIPT" "$PIBENCH_URL" "Storage.sh"

    # Storage.sh takes a directory (mount point) as its argument, not a device
    PIBENCH_RAW=$(bash "$PIBENCH_SCRIPT" "$MOUNTPOINT" 2>&1 | tee /dev/tty) \
        || warn "Storage.sh exited non-zero; capturing output anyway."

    info "Parsing Storage.sh results..."

    # ── Parse Storage.sh output ───────────────────────────────────────────────
    # Storage.sh prints a summary block with lines like:
    #   DD: Write: 132 MB/s
    #   HDParm: Read: 352.04 MB/s
    #   HDParm: Cached: 349.51 MB/s
    #   FIO: 4k Read: 12132 IOPS (48530 KB/s)
    #   FIO: 4k Write: 41967 IOPS (167868 KB/s)
    #   IOZone: 4k Read: 90193  Write: 57748  Random Read: 43397  Random Write: 89487
    #   Score: 16407
    # Exact format may vary by version — we try multiple patterns and fall back gracefully.

    _parse() {
        # _parse "PATTERN" → extracted value, or empty string
        echo "$PIBENCH_RAW" | grep -oP "$1" | head -1 || true
    }

    PB_DD_WRITE=$(_parse    'Write:\s+\K[\d.]+ MB/s' )
    [[ -z "$PB_DD_WRITE"     ]] && PB_DD_WRITE=$(_parse    'DD.*Write.*?:\s+\K[\d.]+ MB/s')
    [[ -z "$PB_DD_WRITE"     ]] && PB_DD_WRITE="TBD"

    PB_HDPARM_READ=$(_parse  'Read:\s+\K[\d.]+ MB/s' | head -1)
    [[ -z "$PB_HDPARM_READ"  ]] && PB_HDPARM_READ="TBD"

    PB_HDPARM_CACHED=$(_parse 'Cached.*?:\s+\K[\d.]+ MB/s')
    [[ -z "$PB_HDPARM_CACHED" ]] && PB_HDPARM_CACHED="TBD"

    # FIO IOPS — Storage.sh prints both read and write on separate lines
    PB_FIO_RR_IOPS=$(_parse  '[Rr]ead.*?:\s+\K[\d,]+ IOPS' | head -1)
    PB_FIO_RW_IOPS=$(_parse  '[Ww]rite.*?:\s+\K[\d,]+ IOPS' | head -1)
    PB_FIO_RR_KB=$(_parse    '[Rr]ead.*?\(?\K[\d,]+ KB/s' | head -1)
    PB_FIO_RW_KB=$(_parse    '[Ww]rite.*?\(?\K[\d,]+ KB/s' | head -1)

    [[ -z "$PB_FIO_RR_IOPS"  ]] && PB_FIO_RR_IOPS="TBD"
    [[ -z "$PB_FIO_RW_IOPS"  ]] && PB_FIO_RW_IOPS="TBD"
    [[ -z "$PB_FIO_RR_KB"    ]] && PB_FIO_RR_KB="TBD"
    [[ -z "$PB_FIO_RW_KB"    ]] && PB_FIO_RW_KB="TBD"

    # IOZone — Storage.sh prints them on one line
    PB_IOZ_READ=$(_parse   'IOZone.*?Read:\s+\K[\d,]+')
    PB_IOZ_WRITE=$(_parse  'IOZone.*?Write:\s+\K[\d,]+')
    PB_IOZ_RREAD=$(_parse  'Random Read:\s+\K[\d,]+')
    PB_IOZ_RWRITE=$(_parse 'Random Write:\s+\K[\d,]+')

    [[ -z "$PB_IOZ_READ"   ]] && PB_IOZ_READ="TBD"
    [[ -z "$PB_IOZ_WRITE"  ]] && PB_IOZ_WRITE="TBD"
    [[ -z "$PB_IOZ_RREAD"  ]] && PB_IOZ_RREAD="TBD"
    [[ -z "$PB_IOZ_RWRITE" ]] && PB_IOZ_RWRITE="TBD"

    PB_SCORE=$(_parse 'Score:\s+\K[\d,]+')
    [[ -z "$PB_SCORE" ]] && PB_SCORE="TBD"

    # Detect whether Storage.sh used "4k" or "4K" in its output
    SIZE_TAG_RAW=$(echo "$PIBENCH_RAW" | grep -oP '[Ff][Ii][Oo].*?[34]([kK])' | grep -oP '[34][kK]' | head -1 || true)
    [[ -n "$SIZE_TAG_RAW" ]] && PB_FIO_SIZE_TAG="$SIZE_TAG_RAW"

    # Benchmark URL (Storage.sh uploads and prints the URL)
    BENCH_URL=$(echo "$PIBENCH_RAW" | grep -oP 'https://pibenchmarks\.com/benchmark/\d+[/]?' | head -1 || true)
    if [[ -n "$BENCH_URL" ]]; then
        BENCH_ID=$(echo "$BENCH_URL" | grep -oP '\d+(?=[/]?$)')
        PB_BENCH_URL_LINE="Full benchmark: [pibenchmarks.com #${BENCH_ID}](${BENCH_URL})"
        info "PiBenchmarks URL: $BENCH_URL"
    else
        warn "No pibenchmarks.com URL found in Storage.sh output; add it manually."
    fi

    info "PiBenchmarks complete. Score: $PB_SCORE"

elif $SKIP_PIBENCH; then
    warn "Skipping PiBenchmarks (-s)."
fi

# =============================================================================
# STEP 5 — Collect filesystem info (after mount, for df output)
# =============================================================================
if ! $DRY_RUN; then
    DF_OUT=$(df -Th "$DEVICE" 2>/dev/null || echo "(df output unavailable)")
fi

# =============================================================================
# STEP 6 — (Optional) Boot Information
# =============================================================================
BOOT_SECTION=""

if $INCLUDE_BOOT; then
    step "Collecting boot information"

    BL_VER=$(vcgencmd bootloader_version 2>/dev/null || echo "(vcgencmd unavailable)")
    BL_CFG=$(vcgencmd bootloader_config  2>/dev/null || echo "(vcgencmd unavailable)")
    LSBLK_BOOT=$(lsblk | grep -E "nvme[0-9]" || true)
    FDISK_BOOT=$(fdisk -l "$DEVICE" 2>/dev/null || echo "(unavailable)")
    NVME_VER=$(nvme version 2>/dev/null || echo "(nvme-cli unavailable)")
    NVME_LIST=$(nvme list 2>/dev/null || echo "(unavailable)")
    NVME_SUBSYS=$(nvme list-subsys 2>/dev/null || echo "(unavailable)")
    NVME_IDCTRL=$(nvme id-ctrl -H "$DEVICE" 2>/dev/null || echo "(unavailable)")
    NVME_LISTNS=$(nvme list-ns "$DEVICE" 2>/dev/null || echo "(unavailable)")
    NVME_IDNS=$(nvme id-ns -H "$DEVICE" --namespace-id=1 2>/dev/null || echo "(unavailable)")

    # Indent nvme-cli output to match the 2-space style in your example files
    _indent2() { sed 's/^/  /'; }

    BOOT_SECTION=$(cat <<BOOT_BLOCK

# Boot Information

## Device Name(s)

\`\`\`
# lsblk | grep nvme[01]
${LSBLK_BOOT}
\`\`\`

## Disk Information

\`\`\`
# fdisk -l ${DEVICE}
${FDISK_BOOT}
\`\`\`

## Bootloader Version

\`\`\`
# vcgencmd bootloader_version
${BL_VER}
\`\`\`

## Bootloader Configuration

\`\`\`
# vcgencmd bootloader_config
${BL_CFG}
\`\`\`

## \`nvme\` Output

<details>
  <summary>Click here to expand...</summary>

  \`\`\`
  # nvme version
$(echo "$NVME_VER" | _indent2)
  \`\`\`

  \`\`\`
  # nvme list
$(echo "$NVME_LIST" | _indent2)
  \`\`\`

  \`\`\`
  # nvme list-subsys
$(echo "$NVME_SUBSYS" | _indent2)
  \`\`\`

  \`\`\`
  # nvme id-ctrl -H ${DEVICE}
$(echo "$NVME_IDCTRL" | _indent2)
  \`\`\`

  \`\`\`
  # nvme list-ns ${DEVICE}
$(echo "$NVME_LISTNS" | _indent2)
  \`\`\`

  \`\`\`
  # nvme id-ns -H ${DEVICE} --namespace-id=1
$(echo "$NVME_IDNS" | _indent2)
  \`\`\`
</details>
BOOT_BLOCK
)
    info "Boot information collected."
fi

# =============================================================================
# STEP 7 — Assemble the markdown report
# =============================================================================
step "Writing markdown report"

# Indent lspci output by 2 spaces (matches your file style inside <details> block)
LSPCI_INDENTED=$(echo "$LSPCI_OUT" | sed 's/^/  /')

# Indent Geerling raw output by 2 spaces
GEERLING_INDENTED=$(echo "$GEERLING_RAW" | sed 's/^/  /')

cat > "$OUTPUT_FILE" <<MARKDOWN
# Product Information

| Product | *(add product URL and name here)* |
|:-|:-|
|----|-----|
| *Name* | *(drive marketing name)* |
| *Model* | *(model number)* |
| *Capacity* | *(e.g. 256GB)* |
| *Form Factor* | *(e.g. M.2 2280)* |
| *Key* | *(e.g. M)* |
| *Interface* | NVMe |
| *Controller* | *(controller chip)* |
| *NAND* | *(NAND type)* |
| *DRAM* | *(DRAM or -)* |
| *Boot Disk* | :white_check_mark: |
| *Non-Boot Disk* | :white_check_mark: |
| *Adapter* | *(adapter model or -)* |

*(Add product review links here)*

# Device Name

\`\`\`
${PROMPT}lsblk | grep nvme[01]
${LSBLK_OUT}
\`\`\`

# Device Information

<details>
  <summary>Click here to expand...</summary>
  
  \`\`\`
  ${PROMPT}lspci -vvv -s ${PCI_ADDR}
${LSPCI_INDENTED}
  \`\`\`
</details>

# Disk Information

\`\`\`
${PROMPT}fdisk -l ${DEVICE}
${FDISK_OUT}
\`\`\`

# Filesystem Information

\`\`\`
${PROMPT}df -Th ${DEVICE}
${DF_OUT}
\`\`\`

# Benchmarks

## PiBenchmarks.com

Credit: [James C. Chambers](https://jamesachambers.com/) ([source](${PIBENCH_URL}))

${PB_BENCH_URL_LINE}

| Category | Test | Result |
|:-|:-|:-|
| DD | Disk Write | ${PB_DD_WRITE} |
| HDParm | Disk Read | ${PB_HDPARM_READ} |
| HDParm | Cached Disk Read | ${PB_HDPARM_CACHED} |
| FIO | ${PB_FIO_SIZE_TAG} Random Read | ${PB_FIO_RR_IOPS} IOPS |
| FIO | ${PB_FIO_SIZE_TAG} Random Write | ${PB_FIO_RW_IOPS} IOPS |
| FIO | ${PB_FIO_SIZE_TAG} Random Read | ${PB_FIO_RR_KB} KB/s |
| FIO | ${PB_FIO_SIZE_TAG} Random Write | ${PB_FIO_RW_KB} KB/s |
| IOZone | ${PB_FIO_SIZE_TAG} Read | ${PB_IOZ_READ} KB/s |
| IOZone | ${PB_FIO_SIZE_TAG} Write | ${PB_IOZ_WRITE} KB/s |
| IOZone | ${PB_FIO_SIZE_TAG} Random Read | ${PB_IOZ_RREAD} KB/s |
| IOZone | ${PB_FIO_SIZE_TAG} Random Write | ${PB_IOZ_RWRITE} KB/s |
| **Score** | | ${PB_SCORE} |

## Jeff Geerling

Credit: [Jeff Geerling](https://www.jeffgeerling.com/) ([source](${GEERLING_URL}))

<details>
  <summary>Click here to expand...</summary>

  \`\`\`
  ${PROMPT}MOUNT_PATH=${MOUNTPOINT} ./disk-benchmark.sh

${GEERLING_INDENTED}
  \`\`\`
</details>
${BOOT_SECTION}
MARKDOWN

info "Report written to: ${OUTPUT_FILE}"

# ── Cleanup: unmount ──────────────────────────────────────────────────────────
if ! $DRY_RUN; then
    step "Cleanup"
    mountpoint -q "$MOUNTPOINT" && umount "$MOUNTPOINT" && info "Unmounted $MOUNTPOINT" || true
fi

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════${NC}"
echo -e "${GREEN} Done!${NC} Output: ${OUTPUT_FILE}"
echo -e "${GREEN}════════════════════════════════════════════════════${NC}"
echo ""
echo " Remember to fill in the Product Information table:"
echo "   - Product name, model, capacity, form factor, key"
echo "   - Controller, NAND type, DRAM"
echo "   - Product URL and review links"
if [[ "$PB_SCORE" == "TBD" ]] || [[ "$PB_DD_WRITE" == "TBD" ]]; then
    echo ""
    echo -e "${YELLOW} Some PiBenchmarks values are TBD — check Storage.sh output.${NC}"
fi
echo ""