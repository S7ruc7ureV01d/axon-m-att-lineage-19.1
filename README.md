# LineageOS 19.1 (Android 12L) for the AT&T ZTE Axon M (P996A25 / fujisan)

Patches that make **LineageOS 19.1** boot and run on the **US AT&T** ZTE Axon M
(model P996A25, eMMC, codename *fujisan*). The public Anya1014CN / AviumUI
fujisan ROMs are built against the China/Japan units and **hang on the AT&T
boot chain**; this set adds the AT&T-specific fixes on top of them.

These are **patches**, not a full ROM. You apply them over the existing public
device, vendor, kernel and LineageOS trees, then build.

> **Status:** V1. SELinux is **permissive**. Built and tested on one AT&T eMMC
> unit on the B37 bootloader. There is **no bootloader unlock and no fastboot**
> on this device — everything is flashed over Qualcomm EDL / recovery
> sideload. See [docs/FLASHING.md](docs/FLASHING.md).

## What these patches fix

| Area | Fix |
|------|-----|
| **GPU / boot hang** | AT&T TrustZone rejects the CN-signed `a530_zap` shader; swap in the AT&T-signed copy (root `f83555bc`) so the GPU comes up |
| **eMMC stability** | Disable CMDQ (`sdhci_msm.nocmdq=1`) on the AT&T eMMC |
| **Boot loop** | Allowlist `STATUS_BAR` for the bundled flashlight priv-app (A12 refuses to boot otherwise); null-guard the Lineage charging-control HAL lookup |
| **Cellular / cnd** | Provide `libprotobuf-old` (QCRIL `libsettings.so` dep) and `libwpa_client` (cnd dep) |
| **Recovery** | configfs USB so adb/sideload work in recovery; light up panel B so the UI spans both screens |
| **Fingerprint** | Run the stock AT&T FPC module under the AOSP 2.1 wrapper with the callback shims the Nougat module needs on A12 (enroll / enumerate / remove / cancel) |
| **Dual-screen touch** | Release stuck fingers when the fold/unfold touch route switches (fixes flaky gesture swipe after folding) |
| **Dual-screen display** | Don't power-cycle panel B on an unfolded wake (fixes the blink/dim-then-ramp) |
| **UX** | Default the Lineage taskbar off (the 2160px unfolded panel otherwise triggers tablet taskbar) |
| **Build** | Silence a `-Werror` unused-parameter break in the msm8996 audio HAL |

## Repository layout

```
local_manifests/fujisan.xml   repo local manifest (adds device/vendor/kernel)
patches/                      git-am patch series, one folder per source repo
  android_device_zte_fujisan/
  android_vendor_zte_fujisan/   (zap + FPC blobs from AT&T B37)
  android_kernel_zte_msm8996/
  lineage-sdk/
  hardware_qcom-caf_msm8996_audio/
docs/BUILDING.md              sync + apply + build
docs/FLASHING.md              EDL / recovery sideload, no fastboot
docs/TOOLS.md                 firmware, tools, XDA research links
apply-patches.sh              applies every series with git am -3
```

## Quick start

```bash
# 1. sync a LineageOS 19.1 tree with the fujisan device/vendor/kernel repos
#    (see docs/BUILDING.md for the manifest + sync)
# 2. from the repo root of your Android source:
/path/to/this-repo/apply-patches.sh /path/to/android-source
# 3. build
source build/envsetup.sh && lunch lineage_fujisan-userdebug && m bacon
```

Full steps: [docs/BUILDING.md](docs/BUILDING.md).

## Base revisions

The patches apply onto these upstream tips (branch `lineage-19.1`). Use
`git am -3` (as `apply-patches.sh` does) so minor upstream drift still applies.

| Repo | Upstream | Base commit |
|------|----------|-------------|
| android_device_zte_fujisan | Anya1014CN | `f62ce16` |
| android_vendor_zte_fujisan | Anya1014CN | `971a567` |
| android_kernel_zte_msm8996 | Anya1014CN | `9d98bc14` |
| lineage-sdk | LineageOS | `dffcdd8` |
| hardware/qcom-caf/msm8996/audio | LineageOS | `dc179c8` |

## Vendor blobs

`patches/android_vendor_zte_fujisan/` swaps the `a530_zap.*` shader for the
AT&T-signed copy and adds the stock AT&T `fingerprint.fpc.so` /
`lib_fpc_tac_shared.so`, all from AT&T **B37** stock firmware (linked in
[docs/TOOLS.md](docs/TOOLS.md)). This is consistent with how the base
`android_vendor_zte_fujisan` tree ships its blobs.

## Credits

- Base device/vendor/kernel trees: **Anya1014CN** / **HanCF1014** (fujisan).
- LineageOS 19.1.
- AT&T-specific research, bring-up and these patches: **S7ruc7ureV01d**, with Claude.
- Firmware, tools and prior research: see [docs/TOOLS.md](docs/TOOLS.md).

No warranty. Flashing firmware over EDL can brick the device. You do this at
your own risk.

## Disclaimer

This project was built with the help of AI (Claude Code). The released build
was tested on real hardware. Use at your own risk.

I'm not responsible for your device exploding, bending, falling apart, or in
any other way deconstructing itself from a failed flash, broken zip alignment,
or thermonuclear war. Nor am I held accountable if you accidentally reflash the
image 3481 times and kill your eMMC chip. If you have any concerns about the
features or modifications included in this ROM, please do some research before
flashing it. You are choosing to make these modifications to your device.
