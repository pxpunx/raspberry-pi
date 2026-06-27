# Product Information

| Product | |
|:-|:-|
|----|----|
| *Name* | Toshiba BG3 |
| *Model* | KBG30ZMS128G |
| *Capacity* | 256GB |
| *Form Factor* | M.2 2280 |
| *Key* | M + B |
| *Interface* | NVMe |
| *Controller* | Custom Toshiba |
| *NAND* | 64L BiCS 3 3D TLC |
| *DRAM* | - |
| *Boot Disk* | :white_check_mark: |
| *Non-Boot Disk* | :white_check_mark: |
| *Adapter* | Ableconn M2MN-151M |

NOTE: KIOXIA and Toshiba are the same.

NOTE: `subsystem` under `lspci` identifies this as a 128GB SSD - it's in fact 256GB.

* [Toshiba Announces BG3 Low-Power NVMe SSD With BiCS3 3D NAND](https://www.anandtech.com/show/11688/toshiba-announces-bg3-lowpower-nvme-ssd-with-bics3-3d-nand)

# Device Name

```
# lsblk | grep nvme[01]
nvme0n1     259:0    0 238.5G  0 disk 
├─nvme0n1p1 259:1    0   256M  0 part 
└─nvme0n1p2 259:2    0 238.2G  0 part 
```

# Device Information

```
# lspci -vvv -s 01:00.0
01:00.0 Non-Volatile memory controller: Toshiba Corporation BG3 x2 NVMe SSD Controller (DRAM-less) (rev 01) (prog-if 02 [NVM Express])
  Subsystem: Toshiba Corporation Toshiba KBG30ZMS128G 128GB NVMe SSD
  Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0
  Interrupt: pin A routed to IRQ 27
  Region 0: Memory at 600000000 (64-bit, non-prefetchable) [size=16K]
  Capabilities: [40] Express (v2) Endpoint, IntMsgNum 0
    DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
      ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0W TEE-IO-
    DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
      RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- FLReset-
      MaxPayload 128 bytes, MaxReadReq 512 bytes
    DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
    LnkCap:	Port #0, Speed 8GT/s, Width x2, ASPM L1, Exit Latency L1 <32us
      ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
    LnkCtl:	ASPM L1 Enabled; RCB 64 bytes, LnkDisable- CommClk+
      ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
    LnkSta:	Speed 5GT/s (downgraded), Width x1 (downgraded)
      TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
    DevCap2: Completion Timeout: Range AB, TimeoutDis+ NROPrPrP- LTR+
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
  Capabilities: [80] Power Management version 3
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
    Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
  Capabilities: [90] MSI: Enable- Count=1/32 Maskable+ 64bit+
    Address: 0000000000000000  Data: 0000
    Masking: 00000000  Pending: 00000000
  Capabilities: [b0] MSI-X: Enable+ Count=32 Masked-
    Vector table: BAR=0 offset=00002000
    PBA: BAR=0 offset=00003000
  Capabilities: [100 v2] Advanced Error Reporting
    UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
      ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
      PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
    UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
      ECRC- UnsupReq- ACSViol- UncorrIntErr- BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
      PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
    UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
      ECRC- UnsupReq- ACSViol- UncorrIntErr+ BlockedTLP- AtomicOpBlocked- TLPBlockedErr-
      PoisonTLPBlocked- DMWrReqBlocked- IDECheck- MisIDETLP- PCRC_CHECK- TLPXlatBlocked-
    CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr- CorrIntErr- HeaderOF-
    CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+ CorrIntErr- HeaderOF-
    AERCap:	First Error Pointer: 00, ECRCGenCap- ECRCGenEn- ECRCChkCap- ECRCChkEn-
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
  Capabilities: [260 v1] Latency Tolerance Reporting
    Max snoop latency: 0ns
    Max no snoop latency: 0ns
  Capabilities: [300 v1] Secondary PCI Express
    LnkCtl3: LnkEquIntrruptEn- PerformEqu-
    LaneErrStat: 0
  Capabilities: [400 v1] L1 PM Substates
    L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1- ASPM_L1.2+ ASPM_L1.1- L1_PM_Substates+
        PortCommonModeRestoreTime=60us PortTPowerOnTime=10us
    L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
          T_CommonMode=0us LTR1.2_Threshold=76800ns
    L1SubCtl2: T_PwrOn=10us
  Kernel driver in use: nvme
  Kernel modules: nvme
```

# Disk Information

```
# fdisk -l /dev/nvme0n1
Disk /dev/nvme0n1: 238.47 GiB, 256060514304 bytes, 500118192 sectors
Disk model: KBG30ZMV256G TOSHIBA                    
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x1975b5ea

Device         Boot  Start       End   Sectors   Size Id Type
/dev/nvme0n1p1        8192    532479    524288   256M  c W95 FAT32 (LBA)
/dev/nvme0n1p2      532480 500118191 499585712 238.2G 83 Linux
```

# Filesystem Information

```
# df -Th /dev/nvme0n1
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/nvme0n1   ext4  235G  2.1M  223G   1% /mnt/sda1
```

# Benchmarks

## PiBenchmarks.com

Credit: [James C. Chambers](https://jamesachambers.com/) ([source](https://raw.githubusercontent.com/TheRemote/PiBenchmarks/master/Storage.sh))

Full benchmark: https://pibenchmarks.com/benchmark/134328/

| Category | Test | Result |
|:-|:-|:-|
| DD | Disk Write | 187 MB/s |
| HDParm | Disk Read | TBD |
| HDParm | Cached Disk Read | 352.38 MB/s |
| FIO | 4k Random Read | 86413 IOPS IOPS |
| FIO | 4k Random Write | 34304 IOPS IOPS |
| FIO | 4k Random Read | 345654 KB/s KB/s |
| FIO | 4k Random Write | 137219 KB/s KB/s |
| IOZone | 4k Read | TBD KB/s |
| IOZone | 4k Write | TBD KB/s |
| IOZone | 4k Random Read | TBD KB/s |
| IOZone | 4k Random Write | TBD KB/s |
| **Score** | | 20806 |

## Jeff Geerling

Credit: [Jeff Geerling](https://www.jeffgeerling.com/) ([source](https://raw.githubusercontent.com/geerlingguy/pi-cluster/master/benchmarks/disk-benchmark.sh))

| Benchmark                  | Result |
| -------------------------- | ------ |
| iozone 4K random read      | 37.43 MB/s |
| iozone 4K random write     | 80.59 MB/s |
| iozone 1M random read      | 337.81 MB/s |
| iozone 1M random write     | 258.95 MB/s |
| iozone 1M sequential read  | 339.17 MB/s |
| iozone 1M sequential write | 260.44 MB/s |
