# Install (AT&T Axon M, P996A25 / Z999, eMMC)

**AT&T eMMC units only.** China/Docomo units use UFS and a different layout.
There is no fastboot: the LineageOS recovery goes in over EDL, then the ROM
is sideloaded from it. Flashing over EDL can brick the phone. At your own risk.

## You need

- From the release: `Axon-M-ATT-EDL-recovery.zip` and
  `lineage-19.1-*-UNOFFICIAL-fujisan.zip`
- A Windows PC with `adb` and the Qualcomm USB driver
  ([QUSB_BULK.zip on XDA](https://xdaforums.com/attachments/qusb_bulk-zip.6244529/))
- Your data backed up: the first install wipes the phone.

`Axon-M-ATT-EDL-recovery.zip` holds everything for the EDL step:

| File | What |
|------|------|
| `prog_emmc_firehose_fujisan.mbn` | AT&T eMMC firehose loader (root `f83555bc`) |
| `rawprogram0.xml`, `patch0.xml` | write `recovery.img` to the recovery partition only (sector 1181696) |
| `recovery.img` | LineageOS 19.1 recovery (F2FS, adb sideload) |
| `QFL/` | Qualcomm Flash Tool (Windows) |

The same loader and QFL are in this repo under [`tools/`](../tools).

## 1. Enter EDL (9008)

- **Phone boots:** enable USB debugging, then `adb reboot edl`.
- **Phone won't boot:** hold **Vol− + Power** to start factory test mode
  (it has adb), then `adb reboot edl`. This works only while `boot` is stock B37.

Device Manager must show **Qualcomm HS-USB QDLoader 9008**.
**QUSB_BULK** is ZTE DFU mode, and you cannot flash from it. Holding both
volume keys while plugging in USB lands there on B37. If you're stuck in DFU,
the [Ultimate DFU Unbrick Tool](https://xdaforums.com/t/guide-tool-the-ultimate-dfu-unbrick-tool.3854229/)
can switch it to 9008. Close that tool right after the switch.

## 2. Flash the recovery with QFL

1. Unzip `Axon-M-ATT-EDL-recovery.zip` and run `QFL/QFL.exe`.
2. **EFL / programmer:** `prog_emmc_firehose_fujisan.mbn`.
   Do **not** use `prog_ufs_firehose_8996` from the XDA root guide; that one is for UFS units.
3. **ROM path:** the unzipped folder (it contains `rawprogram0.xml`).
4. Flash. Only `recovery` is written; boot, system and data stay as they are.

## 3. Install LineageOS

1. Boot into recovery: from Android or factory test mode, run `adb reboot recovery`.
2. **First install:** Factory reset → **Format data**. `/data` must be F2FS,
   and A12 won't boot on data from another ROM. Skip this when updating.
3. Apply update → **Apply from ADB**, then on the PC:
   ```bash
   adb sideload lineage-19.1-*-UNOFFICIAL-fujisan.zip
   ```
4. Reboot. The first boot takes a few minutes.

## If something goes wrong

- **Recovery doesn't boot:** enter EDL again and re-flash it (step 2).
  On Linux, [bkerler/edl](https://github.com/bkerler/edl) can write and read back:
  `edl --loader=prog_emmc_firehose_fujisan.mbn --memory=emmc w recovery recovery.img`
- **Boots straight to recovery every time:** a stuck `misc` command. Erase it:
  `edl --loader=prog_emmc_firehose_fujisan.mbn --memory=emmc e misc`
- More detail: [FLASHING.md](FLASHING.md) · [TOOLS.md](TOOLS.md)
