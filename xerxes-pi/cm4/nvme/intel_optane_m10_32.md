# Product Information

| Product | [Intel® Optane™ Memory M10 Series](https://ark.intel.com/content/www/us/en/ark/products/135581/intel-optane-memory-m10-series-16gb-m-2-80mm-pcie-3-0-20nm-3d-xpoint.html) |
|:-|:-|
|----|----|
| *Name* | Intel Optane M10 |
| *Model* | MEMPEK1J032GAD |
| *Capacity* | 32GB |
| *Form Factor* | M.2 2280 |
| *Key* | M + B |
| *Interface* | NVMe |
| *Optane Controller* | Intel, unknown |
| *Optane Memory* | Intel 3D XPoint |
| *Boot Disk* | :x: (see below) |
| *Non-Boot Disk* | :white_check_mark: |
| *Adapter* | - |

* [The Intel Optane Memory M10 (64GB) Review: Optane Caching Refreshed](https://www.anandtech.com/show/12748/the-intel-optane-memory-m10-64gb-review-optane-caching-refreshed)

This device contains 32GB of Optame (3D XPoint) memory. It will not boot a CM4.

# Device Name

```
# lsblk | grep nvme[01]
nvme0n1     259:0    0 27.3G  0 disk 
├─nvme0n1p1 259:1    0  256M  0 part 
└─nvme0n1p2 259:2    0  1.6G  0 part 
```

# Device Information

```
# lspci -vvv -s 01:00.0
01:00.0 Non-Volatile memory controller: Intel Corporation NVMe Optane Memory Series (prog-if 02 [NVM Express])
  Subsystem: Intel Corporation Optane Memory M10 16GB
  Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0
  Interrupt: pin A routed to IRQ 27
  Region 0: Memory at 600000000 (64-bit, non-prefetchable) [size=16K]
  Capabilities: [40] Power Management version 3
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
    Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
  Capabilities: [50] MSI-X: Enable+ Count=9 Masked-
    Vector table: BAR=0 offset=00002000
    PBA: BAR=0 offset=00003000
  Capabilities: [60] Express (v2) Endpoint, IntMsgNum 0
    DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
      ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0W TEE-IO-
    DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
      RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+ FLReset-
      MaxPayload 128 bytes, MaxReadReq 512 bytes
    DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
    LnkCap:	Port #0, Speed 8GT/s, Width x2, ASPM L1, Exit Latency L1 unlimited
      ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
    LnkCtl:	ASPM L1 Enabled; RCB 64 bytes, LnkDisable- CommClk+
      ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
    LnkSta:	Speed 5GT/s (downgraded), Width x1 (downgraded)
      TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
    DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ NROPrPrP- LTR+
        10BitTagComp- 10BitTagReq- OBFF Not Supported, ExtFmt- EETLPPrefix-
        EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
        FRS- TPHComp- ExtTPHComp-
        AtomicOpsCap: 32bit- 64bit- 128bitCAS-
    DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
        AtomicOpsCtl: ReqEn-
        IDOReq- IDOCompl- LTR+ EmergencyPowerReductionReq-
        10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
    LnkCap2: Supported Link Speeds: 2.5-8GT/s, Crosslink- Retimer- 2Retimers- DRS-
    LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
        Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
        Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
    LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete- EqualizationPhase1-
        EqualizationPhase2- EqualizationPhase3- LinkEqualizationRequest-
        Retimer- 2Retimers- CrosslinkRes: unsupported
  Capabilities: [a0] MSI: Enable- Count=1/16 Maskable+ 64bit+
    Address: 0000000000000000  Data: 0000
    Masking: 00000000  Pending: 00000000
  Capabilities: [100 v1] Advanced Error Reporting
    UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
      ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
      PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
    UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
      ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
      PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
    UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
      ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
      PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
    CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr- CorrIntErr- HeaderOF-
    CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+ CorrIntErr- HeaderOF-
    AERCap:	First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
      MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
    HeaderLog: 00000000 00000000 00000000 00000000
  Capabilities: [150 v1] Virtual Channel
    Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
    Arb:	Fixed- WRR32- WRR64- WRR128-
    Ctrl:	ArbSelect=Fixed
    Status:	InProgress-
    VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
      Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
      Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
      Status:	NegoPending- InProgress-
  Capabilities: [180 v1] Power Budgeting <?>
  Capabilities: [190 v1] Alternative Routing-ID Interpretation (ARI)
    ARICap:	MFVC- ACS-, Next Function: 0
    ARICtl:	MFVC- ACS-, Function Group: 0
  Capabilities: [2a0 v1] Secondary PCI Express
    LnkCtl3: LnkEquIntrruptEn- PerformEqu-
    LaneErrStat: 0
  Capabilities: [2d0 v1] Latency Tolerance Reporting
    Max snoop latency: 0ns
    Max no snoop latency: 0ns
  Capabilities: [310 v1] L1 PM Substates
    L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
        PortCommonModeRestoreTime=100us PortTPowerOnTime=3100us
    L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
          T_CommonMode=0us LTR1.2_Threshold=3211264ns
    L1SubCtl2: T_PwrOn=3100us
  Kernel driver in use: nvme
  Kernel modules: nvme
```

# Disk Information

```
# fdisk -l /dev/nvme0n1
Disk /dev/nvme0n1: 27.25 GiB, 29260513280 bytes, 57149440 sectors
Disk model: INTEL MEMPEK1J032GAD                    
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x21e60f8c

Device         Boot  Start     End Sectors  Size Id Type
/dev/nvme0n1p1        8192  532479  524288  256M  c W95 FAT32 (LBA)
/dev/nvme0n1p2      532480 3923967 3391488  1.6G 83 Linux
```

# Filesystem Information

```
# df -Th /dev/nvme0n1
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/nvme0n1   ext4   27G  2.1M   26G   1% /mnt/sda1
```

# Benchmarks

## PiBenchmarks.com

Credit: [James C. Chambers](https://jamesachambers.com/) ([source](https://raw.githubusercontent.com/TheRemote/PiBenchmarks/master/Storage.sh))

Full benchmark: https://pibenchmarks.com/benchmark/134327/

| Category | Test | Result |
|:-|:-|:-|
| DD | Disk Write | 190 MB/s |
| HDParm | Disk Read | TBD |
| HDParm | Cached Disk Read | 362.78 MB/s |
| FIO | 4k Random Read | 55202 IOPS IOPS |
| FIO | 4k Random Write | 40235 IOPS IOPS |
| FIO | 4k Random Read | 220808 KB/s KB/s |
| FIO | 4k Random Write | 160943 KB/s KB/s |
| IOZone | 4k Read | TBD KB/s |
| IOZone | 4k Write | TBD KB/s |
| IOZone | 4k Random Read | TBD KB/s |
| IOZone | 4k Random Write | TBD KB/s |
| **Score** | | 26352 |

## Jeff Geerling

Credit: [Jeff Geerling](https://www.jeffgeerling.com/) ([source](https://raw.githubusercontent.com/geerlingguy/pi-cluster/master/benchmarks/disk-benchmark.sh))

| Benchmark                  | Result |
| -------------------------- | ------ |
| iozone 4K random read      | 124.06 MB/s |
| iozone 4K random write     | 107.69 MB/s |
| iozone 1M random read      | 354.93 MB/s |
| iozone 1M random write     | 324.09 MB/s |
| iozone 1M sequential read  | 355.21 MB/s |
| iozone 1M sequential write | 323.23 MB/s |
