# Product Information

| Product | [WD Blue SN570 NVMe™ SSD](https://www.westerndigital.com/products/internal-drives/wd-blue-sn570-nvme-ssd) |
|:-|:-|
|----|----|
| *Name* | Western Digital Blue SN570 |
| *Model* | WDS250G3B0C-00AZN0 |
| *Capacity* | 250GB |
| *Form Factor* | M.2 2280 |
| *Key* | M |
| *Interface* | NVMe |
| *Controller* | Custom SanDisk |
| *NAND* | SanDisk (Toshiba?) 112L 3D TLC BiCS5 |
| *DRAM* | - |
| *Boot Disk* | :white_check_mark: |
| *Non-Boot Disk* | :white_check_mark: |
| *Adapter* | - |

* [Western Digital Updates WD Blue Series with SN570 DRAM-less NVMe SSD](https://www.anandtech.com/show/16988/western-digital-updates-wd-blue-series-with-sn570-dramless-nvme-ssd)
* [WD Blue SN570 M.2 NVMe SSD Review: Bleeding-Edge Bargain](https://www.tomshardware.com/reviews/wd-blue-sn570-review)
* [WD Blue SN570 1TB NVMe SSD Review](https://www.servethehome.com/wd-blue-sn570-1tb-nvme-ssd-review/)

# Device Name

```
# lsblk | grep nvme[01]
nvme0n1     259:0    0 232.9G  0 disk 
├─nvme0n1p1 259:1    0   256M  0 part 
└─nvme0n1p2 259:2    0 232.6G  0 part 
```

# Device Information

```
# lspci -vvv -s 01:00.0
01:00.0 Non-Volatile memory controller: Sandisk Corp SanDisk Ultra 3D / WD Blue SN570 NVMe SSD (DRAM-less) (prog-if 02 [NVM Express])
  Subsystem: Sandisk Corp SanDisk Ultra 3D / WD Blue SN570 NVMe SSD (DRAM-less)
  Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0
  Interrupt: pin A routed to IRQ 27
  Region 0: Memory at 600000000 (64-bit, non-prefetchable) [size=16K]
  Region 4: Memory at 600004000 (64-bit, non-prefetchable) [size=256]
  Capabilities: [80] Power Management version 3
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
    Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
  Capabilities: [90] MSI: Enable- Count=1/32 Maskable- 64bit+
    Address: 0000000000000000  Data: 0000
  Capabilities: [b0] MSI-X: Enable+ Count=17 Masked-
    Vector table: BAR=0 offset=00002000
    PBA: BAR=4 offset=00000000
  Capabilities: [c0] Express (v2) Endpoint, IntMsgNum 0
    DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <1us, L1 unlimited
      ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0W TEE-IO-
    DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
      RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
      MaxPayload 128 bytes, MaxReadReq 512 bytes
    DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
    LnkCap:	Port #0, Speed 8GT/s, Width x4, ASPM L1, Exit Latency L1 <8us
      ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
    LnkCtl:	ASPM L1 Enabled; RCB 64 bytes, LnkDisable- CommClk+
      ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
    LnkSta:	Speed 5GT/s (downgraded), Width x1 (downgraded)
      TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
    DevCap2: Completion Timeout: Range B, TimeoutDis+ NROPrPrP- LTR+
        10BitTagComp- 10BitTagReq- OBFF Not Supported, ExtFmt+ EETLPPrefix-
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
  Capabilities: [100 v2] Advanced Error Reporting
    UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
      ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
      PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
    UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
      ECRC- UnsupReq- ACSViol- UncorrIntErr+ BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
      PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
    UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
      ECRC- UnsupReq- ACSViol- UncorrIntErr+ BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
      PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
    CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr- CorrIntErr- HeaderOF-
    CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+ CorrIntErr+ HeaderOF+
    AERCap:	First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
      MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
    HeaderLog: 00000000 00000000 00000000 00000000
  Capabilities: [150 v1] Device Serial Number 00-00-00-00-00-00-00-00
  Capabilities: [1b8 v1] Latency Tolerance Reporting
    Max snoop latency: 0ns
    Max no snoop latency: 0ns
  Capabilities: [300 v1] Secondary PCI Express
    LnkCtl3: LnkEquIntrruptEn- PerformEqu-
    LaneErrStat: 0
  Capabilities: [900 v1] L1 PM Substates
    L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1- ASPM_L1.2+ ASPM_L1.1- L1_PM_Substates+
        PortCommonModeRestoreTime=32us PortTPowerOnTime=10us
    L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
          T_CommonMode=0us LTR1.2_Threshold=48128ns
    L1SubCtl2: T_PwrOn=10us
  Kernel driver in use: nvme
  Kernel modules: nvme
```

# Disk Information

```
# fdisk -l /dev/nvme0n1
Disk /dev/nvme0n1: 232.89 GiB, 250059350016 bytes, 488397168 sectors
Disk model: WD Blue SN570 250GB                     
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x65112a77

Device         Boot  Start       End   Sectors   Size Id Type
/dev/nvme0n1p1        8192    532479    524288   256M  c W95 FAT32 (LBA)
/dev/nvme0n1p2      532480 488397167 487864688 232.6G 83 Linux
```

# Filesystem Information

```
# df -Th /dev/nvme0n1
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/nvme0n1   ext4  230G  2.1M  218G   1% /mnt/sda1
```

# Benchmarks

## PiBenchmarks.com

Credit: [James C. Chambers](https://jamesachambers.com/) ([source](https://raw.githubusercontent.com/TheRemote/PiBenchmarks/master/Storage.sh))

Full benchmark: https://pibenchmarks.com/benchmark/134318/

| Category | Test | Result |
|:-|:-|:-|
| DD | Disk Write | 211 MB/s |
| HDParm | Disk Read | TBD |
| HDParm | Cached Disk Read | 358.88 MB/s |
| FIO | 4k Random Read | 87521 IOPS IOPS |
| FIO | 4k Random Write | 40156 IOPS IOPS |
| FIO | 4k Random Read | 350085 KB/s KB/s |
| FIO | 4k Random Write | 160627 KB/s KB/s |
| IOZone | 4k Read | TBD KB/s |
| IOZone | 4k Write | TBD KB/s |
| IOZone | 4k Random Read | TBD KB/s |
| IOZone | 4k Random Write | TBD KB/s |
| **Score** | | 23849 |

## Jeff Geerling

Credit: [Jeff Geerling](https://www.jeffgeerling.com/) ([source](https://raw.githubusercontent.com/geerlingguy/pi-cluster/master/benchmarks/disk-benchmark.sh))

  | Benchmark                  | Result |
  | -------------------------- | ------ |
  | iozone 4K random read      | 44.98 MB/s |
  | iozone 4K random write     | 104.73 MB/s |
  | iozone 1M random read      | 346.53 MB/s |
  | iozone 1M random write     | 356.76 MB/s |
  | iozone 1M sequential read  | 346.70 MB/s |
  | iozone 1M sequential write | 357.61 MB/s |
