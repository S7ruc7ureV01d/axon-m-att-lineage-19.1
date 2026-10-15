# Flashing

**There is no bootloader unlock and no working fastboot on the AT&T Axon M.**
The bootloader accepts boot/recovery images that carry a valid AOSP
BootSignature trailer (any signer), but it will not enter fastboot. Everything
is flashed over **Qualcomm EDL (9008)** or **recovery sideload**.

> Firmware flashing over EDL can permanently brick the phone. Read
> [TOOLS.md](TOOLS.md) and verify every write by reading it back. Do this at
> your own risk.

Short version: [INSTALL.md](INSTALL.md). This page has the details.

## Prerequisites

- An AT&T unit already on the **B37** chain, with a working recovery
  (LineageOS recovery from this build, or TWRP 3.2.3 — **not** 3.5.2/3.7,
  which fail on this unit). To get there from stock, see the EDL root guide
  and firehose links in [TOOLS.md](TOOLS.md).
- The AT&T **B37** firehose programmer (`prog_emmc_firehose_fujisan.mbn`,
  root `f83555bc`) for any EDL work.
- `adb` and [bkerler/edl](https://github.com/bkerler/edl).

## Recommended: recovery sideload

The LineageOS recovery built from this tree handles F2FS and has working adb
(the stock public recovery does not bring up USB on this device — that is one
of the patches here).

1. Boot recovery.
2. **First install only — wipe `/data`:** Factory reset → Format data. A12
   will not boot on Android-16-era `/data`, and `/data` must come up as
   **F2FS** (the fstab is `f2fs … formattable`, so a blank partition is
   formatted on first boot). Skip this on dirty-flash updates.
3. Apply update → Apply from ADB:
   ```bash
   adb sideload lineage-19.1-*-UNOFFICIAL-fujisan.zip
   ```
   The zip writes `system` and `boot` and keeps the installed recovery.
4. Reboot. First boot takes a few minutes.

## Flashing recovery itself (from a running rooted system or EDL)

The recovery partition has no `/dev/block/bootdevice` symlink in recovery;
use the platform path. From a rooted system or recovery adb-root shell:

```bash
P=/dev/block/platform/soc/7464900.sdhci/by-name/recovery
adb push recovery.img /data/local/tmp/recovery.img
adb shell "dd if=/data/local/tmp/recovery.img of=$P bs=1M conv=fsync; sync"
# verify
adb shell "dd if=$P bs=$(stat -c%s recovery.img) count=1 | sha256sum"
```

Compare the readback sha against the local image. Over EDL, write with the
B37 firehose and the official B37 eMMC offsets (boot sector 1050624, recovery
1181696) — **not** the offsets inside a random TWRP zip.

## Rollback

Keep your pre-flash `boot`/`recovery`/`system` (or a full stock B37 EDL
package) so you can restore over EDL. The GPU zap, F2FS and BootSignature
requirements are AT&T-specific; a CN/JP image will not boot on this chain.
