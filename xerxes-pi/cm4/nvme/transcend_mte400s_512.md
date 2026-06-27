# Product Information

| Product | [PCIe SSD 400S | PCIe M.2 SSDs - Transcend Information, Inc.](https://us.transcend-info.com/product/internal-ssd/mte400s) |
|:-|:-|
|----|-----|
| *Name* | Transcend MTE400s |
| *Model* | TS512GMTE400S |
| *Capacity* | 512GB |
| *Form Factor* | 2242 |
| *Key* | M |
| *Interface* | NVMe |
| *Controller* | Silicon Motion SM2263XT |
| *NAND* | 3D TLC |
| *DRAM* | - |
| *Boot Disk* | :white_check_mark: |
| *Non-Boot Disk* | :white_check_mark: |
| *Adapter* | Ableconn M2MN-151M |

# Device Name

```
# lsblk | grep nvme[01]
nvme0n1     259:0    0 476.9G  0 disk 
```

# Device Information

```
# lspci -vvv -s 01:00.0
01:00.0 Non-Volatile memory controller: Transcend Information, Inc. NVMe PCIe SSD 110S/112S/120S/MTE300S/MTE400S/MTE652T2 (DRAM-less) (rev 03) (prog-if 02 [NVM Express])
  Subsystem: Transcend Information, Inc. NVMe PCIe SSD 110S/112S/120S/MTE300S/MTE400S/MTE652T2 (DRAM-less)
  Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0
  Interrupt: pin A routed to IRQ 27
  Region 0: Memory at 600000000 (64-bit, non-prefetchable) [size=16K]
  Capabilities: [40] Power Management version 3
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
    Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
  Capabilities: [50] MSI: Enable- Count=1/8 Maskable+ 64bit+
    Address: 0000000000000000  Data: 0000
    Masking: 00000000  Pending: 00000000
  Capabilities: [70] Express (v2) Endpoint, IntMsgNum 0
    DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
      ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0W TEE-IO-
    DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
      RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop- FLReset-
      MaxPayload 128 bytes, MaxReadReq 512 bytes
    DevSta:	CorrErr+ NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
    LnkCap:	Port #0, Speed 8GT/s, Width x4, ASPM L1, Exit Latency L1 <8us
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
  Capabilities: [b0] MSI-X: Enable+ Count=16 Masked-
    Vector table: BAR=0 offset=00002000
    PBA: BAR=0 offset=00002100
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
  Capabilities: [158 v1] Secondary PCI Express
    LnkCtl3: LnkEquIntrruptEn- PerformEqu-
    LaneErrStat: 0
  Capabilities: [178 v1] Latency Tolerance Reporting
    Max snoop latency: 0ns
    Max no snoop latency: 0ns
  Capabilities: [180 v1] L1 PM Substates
    L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
        PortCommonModeRestoreTime=10us PortTPowerOnTime=10us
    L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
          T_CommonMode=0us LTR1.2_Threshold=26016ns
    L1SubCtl2: T_PwrOn=10us
  Kernel driver in use: nvme
  Kernel modules: nvme
```

# Disk Information

```
# fdisk -l /dev/nvme0n1
Disk /dev/nvme0n1: 476.94 GiB, 512110190592 bytes, 1000215216 sectors
Disk model: TS512GMTE400S                           
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

# Filesystem Information

```
# df -Th /dev/nvme0n1
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/nvme0n1   ext4  470G  2.1M  446G   1% /mnt/sda1
```

# Benchmarks

## PiBenchmarks.com

Credit: [James C. Chambers](https://jamesachambers.com/) ([source](https://raw.githubusercontent.com/TheRemote/PiBenchmarks/master/Storage.sh))

Full benchmark: https://pibenchmarks.com/benchmark/134332/

| Category | Test | Result |
|:-|:-|:-|
| DD | Disk Write | 203 MB/s |
| HDParm | Disk Read | TBD |
| HDParm | Cached Disk Read | 331.96 MB/s |
| FIO | 4k Random Read | 62822 IOPS IOPS |
| FIO | 4k Random Write | 36571 IOPS IOPS |
| FIO | 4k Random Read | 251288 KB/s KB/s |
| FIO | 4k Random Write | 146285 KB/s KB/s |
| IOZone | 4k Read | TBD KB/s |
| IOZone | 4k Write | TBD KB/s |
| IOZone | 4k Random Read | TBD KB/s |
| IOZone | 4k Random Write | TBD KB/s |
| **Score** | | 21217 |

## Jeff Geerling

Credit: [Jeff Geerling](https://www.jeffgeerling.com/) ([source](https://raw.githubusercontent.com/geerlingguy/pi-cluster/master/benchmarks/disk-benchmark.sh))

| Benchmark                  | Result |
| -------------------------- | ------ |
| iozone 4K random read      | 23.88 MB/s |
| iozone 4K random write     | 95.72 MB/s |
| iozone 1M random read      | 311.40 MB/s |
| iozone 1M random write     | 308.56 MB/s |
| iozone 1M sequential read  | 322.45 MB/s |
| iozone 1M sequential write | 318.95 MB/s |
