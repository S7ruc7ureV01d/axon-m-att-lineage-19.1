# Tools, firmware and research

Links to the firmware, tools and XDA research these patches build on. External
links; availability not guaranteed.

## Base ROM trees (fujisan)

- [Anya1014CN/android_device_zte_fujisan](https://github.com/Anya1014CN/android_device_zte_fujisan) (branches lineage-15.1 / 18.1 / 19.1 / 23.2)
- [Anya1014CN/android_vendor_zte_fujisan](https://github.com/Anya1014CN/android_vendor_zte_fujisan)
- [Anya1014CN/android_kernel_zte_msm8996](https://github.com/Anya1014CN/android_kernel_zte_msm8996)
- [Anya1014CN/twrp_device_zte_fujisan](https://github.com/Anya1014CN/twrp_device_zte_fujisan)
- Older: [deadman96385/twrp_device_zte_fujisan](https://github.com/deadman96385/twrp_device_zte_fujisan) · [Fairzonex/android_kernel_zte_fujisan_msm8996pro](https://github.com/Fairzonex/android_kernel_zte_fujisan_msm8996pro) · [twrpdtgen/android_device_zte_fujisan](https://github.com/twrpdtgen/android_device_zte_fujisan)

## Flashing / root tools

- [bkerler/edl](https://github.com/bkerler/edl) — Qualcomm EDL (9008) client, used for all firmware R/W.
- [AT&T Z999 B37 eMMC root guide (oneplussix, XDA)](https://xdaforums.com/t/guide-zte-axon-m-us-z999-att-emmc-root.4803967/) — pull `boot` via edl + the B37 firehose, patch with **Magisk v26.0** (newer versions bootloop and cost you EDL access), pad to size, write back, erase userdata. The route onto the B37 chain for a stock unit.
- A phone stuck in ZTE DFU (`19d2:0112`, QUSB_BULK) needs a separate DFU→EDL step (ZTE after-sales `DFU_MultiDL`). Real EDL is `05c6:9008` via `adb reboot edl` or Vol+ & Vol− while plugging in USB.

## Recovery

- [TWRP 3.2.3-0 (Unjustified Dev, 2019)](https://xdaforums.com/t/recovery-3-2-3-0-fujisan-unofficial-twrp-recovery-for-axon-m.3959314/) — the TWRP that boots on the B37 bootloader. Do **not** use the sector offsets in its own `rawprogram0.xml`; recovery on the AT&T eMMC is at sector 1181696.
- [TWRP 3.7.0_9 (HanCF1014, 2026)](https://xdaforums.com/t/recovery-3-7-0_9-fujisan-unofficial-twrp-recovery-for-axon-m.4793131/) and [TWRP 3.5.2](https://xdaforums.com/t/recovery-fujisan-unofficial-twrp-3-5-2-for-zte-axon-m-z-01k.4787243/) — do not boot reliably on this AT&T unit; prefer the LineageOS recovery from this build.

## Stock firmware & firehose ([deadman96385 thread](https://xdaforums.com/t/rom-zte-axon-m-stock-firmware-firehose.3909847/))

- EDL packages: [AT&T B30](https://www.androidfilehost.com/?fid=1395089523397912640) · [AT&T B37](https://www.androidfilehost.com/?fid=1395089523397912610) · [China Oreo 2.1](https://www.androidfilehost.com/?fid=1395089523397912611) · [Docomo Z-01K B32](https://www.androidfilehost.com/?fid=1395089523397913318)
- Firehoses: [AT&T](https://www.androidfilehost.com/?fid=1395089523397896976) · [Docomo](https://www.androidfilehost.com/?fid=1395089523397896977) · [TIM](https://www.androidfilehost.com/?fid=1395089523397912639)
- **B37** is the build the AT&T root guide and these patches target.

## Research

- [ZTE Axon M research thread (XDA)](https://xdaforums.com/t/zte-axon-m-research.3984195/) — signing, aboot, fastboot OEM commands by ROM.
- [AviumUI 16.2 (XDA)](https://xdaforums.com/t/rom-unofficial-16-aviumui-16-2-for-zte-axon-m-2026-10-06.4804066/) — the Android 16 fujisan ROM with the same base; same AT&T boot failure these patches address for 19.1.
- [B22 kernel source drop (ZTE, 2018)](https://xdaforums.com/f/zte-axon-m-guides-news-discussion.7139/).

## Device facts (AT&T P996A25, B37)

- Fused secure-boot root: `f83555bc`. Only AT&T-signed firmware runs; CN/JP/RU
  images and CN-signed `a530_zap` are rejected by the boot ROM / TrustZone.
- No fastboot / no bootloader unlock. aboot gates fastboot behind an
  RSA-signed, model-bound token that retail units do not carry.
- Bootloader verifies an AOSP BootSignature DER trailer on boot/recovery
  (length field must match); the LineageOS boot signer satisfies it.
- `/data` is F2FS.
