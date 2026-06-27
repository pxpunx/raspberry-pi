Notes from my M.2 SSD tests on the Xerxes Pi Rev2 platform.

# Product List

A list of NVMe SSDs tested with the Xerxes Pi Rev2 w/ CM4 8GB Lite (CM4008000). All SSDs work as non-boot disks, but some do not work as boot disks.

| Product                                          | Model              | Capactiy     | Form Factor | Key   | Boot Disk          | Non-Boot Disk      |
|:-------------------------------------------------|:-------------------|:-------------|:------------|:------|:-------------------|:-------------------|
| [Crucial P3](crucial_p3_500.md)                  | CT500P3SSD8        | 500GB        | M.2 2280    | M     | :white_check_mark: | :white_check_mark: |
| [Intel 670p](intel_670p_512.md)                  | SSDPEKNU512GZ      | 512GB        | M.2 2280    | M     | :white_check_mark: | :white_check_mark: |
| [Intel Optane M10](intel_optane_m10_32.md)       | MEMPEK1J032GAD     | 32GB         | M.2 2280    | M + B | :x:                | :white_check_mark: |
| [Kingston NV2](kingston_nv2_250.md)              | SNV2S/250G         | 250GB        | M.2 2280    | M     | :white_check_mark: | :white_check_mark: |
| [Kingston SNS8154P3](kingston_sns8154p3_256.md)  | RBUSNS8154P3256GJ1 | 256GB        | M.2 2280    | M + B | :white_check_mark: | :white_check_mark: |
| [KIOXIA BG4](kioxia_bg4_128.md)                  | KBG40ZNS128G       | 128GB        | M.2 2230    | M     | :white_check_mark: | :white_check_mark: |
| [Micron 2450](micron_2450_256.md)                | MTFDKBA256TFK      | 256GB        | M.2 2280    | M     | :white_check_mark: | :white_check_mark: |
| [Micron 3400](micron_3400_512.md)                | MTFDKBA512TFH      | 512GB        | M.2 2280    | M     | :white_check_mark: | :white_check_mark: |
| [Patriot P310](patriot_p310_240.md)              | P310P240GM28       | 240GB        | M.2 2280    | M     | :white_check_mark: | :white_check_mark: |
| [PNY CS1030](pny_cs1030_250.md)                  | M280CS1030-250-RB  | 250GB        | M.2 2280    | M     | :white_check_mark: | :white_check_mark: |
| [Samsung 970 EVO](sec_970_evo_500.md)            | MZ-V7E500          | 500GB        | M.2 2280    | M     | :white_check_mark: | :white_check_mark: |
| [Samsumg PM991a](sec_pm991a_256.md)              | MZ9LQ256HBJ        | 256GB        | M.2 2230    | M     | :white_check_mark: | :white_check_mark: |
| [SK hynix BC711](skhynix_bc711_256.md)           | HFM256GD3JX016N    | 256GB        | M.2 2280    | M     | :white_check_mark: | :white_check_mark: |
| [Solidigm P41 Plus](solidigm_p41_plus_512.md)    | SSDPFKNU512GZ      | 512GB        | M.2 2280    | M     | :white_check_mark: | :white_check_mark: |
| [TEAMGROUP MP33](teamgroup_mp33_256.md)          | TM8FP6256G0C101    | 256GB        | M.2 2280    | M     | :white_check_mark: | :white_check_mark: |
| [Toshiba BG3](toshiba_bg3_256.md)                | KBG30ZMS128G       | 256GB        | M.2 2280    | M + B | :white_check_mark: | :white_check_mark: |
| [Transcend 110S](transcend_110s_256.md)          | TS256GMTE110S      | 256GB        | M.2 2280    | M     | :white_check_mark: | :white_check_mark: |
| [WD Blue SN570](wd_blue_sn570_250.md)            | WDS250G3B0C        | 250GB        | M.2 2280    | M     | :white_check_mark: | :white_check_mark: |
| [WD Green SN350](wd_green_sn350_240.md)          | WDS240G2G0C        | 240GB        | M.2 2280    | M     | :white_check_mark: | :white_check_mark: |
| [WD Red SN700](wd_red_sn700_500.md)              | WDS500G1R0C        | 500GB        | M.2 2280    | M     | :white_check_mark: | :white_check_mark: |
| [WD SN520](wd_sn520_256.md)                      | SDAPNUW-256G-1006  | 256GB        | M.2 2280    | M + B | :white_check_mark: | :white_check_mark: |
| [Raspberry Pi SSD 256GB](raspberry_pi_256.md)    | OEM MZ9LQ256HBJ    | 256GB        | M.2 2230    | M     | :white_check_mark: | :white_check_mark: |
| [Transcend MTE400s](transcend_mte400s_512.md)    | TS512GMTE400S      | 512GB        | M.2 2242    | M     | :white_check_mark: | :white_check_mark: |

See individual product details for benchmarks.

Most drives were tested with the use of an [Ableconn M2MN-151M](http://ableconn.com/products_2.php?gid=137) adapter to preserve the Xerxes Pi's M.2 connector as well as add a 2280 mount point, as the Xerxes Pi does not have one. 

# NVMe Benchmark

> [!NOTE] I used Claude to automate the benchmark steps below. I've uploaded [a copy of the script](nvme_benchmark.sh). Use at your own risk.

The steps I used to set up each test and collect information. Total power draw while tests were performed was between 4W and 6W on a [USW Pro 24 PoE](https://store.ui.com/collections/unifi-network-switching/products/usw-pro-24-poe) PoE++ (60W) port.

* `lsblk` to find device name.
* `lspci -vvv -s 01:00.0` to collect device info.
* `fdisk -l /dev/nvme0n1` to collect disk info.
* `fdisk /dev/nvme0n1` to partition disk.
  * `d` to delete partition(s).
  * `n` to create partition(s).
  * `w` to write (save) and exit.
* `mkfs.ext4 -F /dev/nvme0n1` to format disk.
* `mkdir /mnt/sda1` to create mount point.
* `mount /dev/nvme0n1 /mnt/sda1` to mount disk.
* `df -Th /dev/nvme0n1` to confirm filesystem and mount.
* `curl -O https://raw.githubusercontent.com/geerlingguy/pi-cluster/master/benchmarks/disk-benchmark.sh` to download [Jeff Geerling's](https://www.jeffgeerling.com/) benchmark script.
* `chmod +x disk-benchmark.sh` to enable execution.
* `DEVICE_UNDER_TEST=/dev/nvme0n1 ./disk-benchmark.sh` to run benchmark.
* `curl -O https://raw.githubusercontent.com/TheRemote/PiBenchmarks/master/Storage.sh` to download [pibenchmarks.com's](https://pibenchmarks.com) benchmark script.
* `chmod +x Storage.sh` to enable execution.
* `./Storage.sh /dev/nvme0n1` to run benchmark.

# NVMe Boot Imaging

NVMe SSDs can be imaged the same way you'd image a microSD card.

* **OS:** macOS Ventura 13.1
* **Adapter:** [ICY DOCK MB104U-1SMB](https://global.icydock.com/product_322.html) w/ [Realtek RTL9210B](https://www.realtek.com/en/products/communications-network-ics/item/rtl9210b-cg)
* **Tool:** Raspberry Pi Imager v2.0.10
  * Options:
    * Set name.
    * Enable SSH w/ public key authentication.
    * Set username and password as a backup.
    * Set locale.

I used the ICY DOCK adapter and the official Raspberry Pi Imager to image the M.2 NVMe SSD with Raspberry Pi OS Lite (64-bit).

## Options

> [!NOTE] I used a new CM400800 for the Xerxes Pi Rev2 tests. It did not require me to update the boot configuration.

# Enable NVMe Boot

> [!NOTE] I used a new CM400800 for the Xerxes Pi Rev2 tests. It did not require me to enable NVME boot.

# Resources

* [Raspberry Pi Documentation > Raspberry Pi Hardware > NVMe SSD Boot](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#nvme-ssd-boot) _(same as link below)_
* [raspberrypi/documentation > NVMe SSD Boot](https://github.com/raspberrypi/documentation/blob/develop/documentation/asciidoc/computers/raspberry-pi/boot-nvme.adoc) _(same as link above)_
* [Raspberry Pi Documentation > Compute Module Hardware > Flashing the Compute Module eMMC > Compute Module 4 Bootloader](https://www.raspberrypi.com/documentation/computers/compute-module.html#compute-module-4-bootloader)
* [raspberrypi/usbboot](https://github.com/raspberrypi/usbboot)
