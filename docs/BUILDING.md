# Building

## 1. Set up a LineageOS 19.1 source tree

```bash
mkdir lineage-19.1 && cd lineage-19.1
repo init -u https://github.com/LineageOS/android.git -b lineage-19.1 --git-lfs
```

Add the fujisan device/vendor/kernel repos with a local manifest. Copy
`local_manifests/fujisan.xml` from this repo:

```bash
mkdir -p .repo/local_manifests
cp /path/to/this-repo/local_manifests/fujisan.xml .repo/local_manifests/
repo sync -c -j"$(nproc)"
```

This pulls the Anya1014CN `android_device_zte_fujisan`,
`android_vendor_zte_fujisan` and `android_kernel_zte_msm8996` (branch
`lineage-19.1`) alongside the LineageOS trees.

## 2. Apply the patches

From the root of the Android source tree:

```bash
/path/to/this-repo/apply-patches.sh "$PWD"
```

The script runs `git am -3` for each series in `patches/`. It applies onto the
base commits in the README table; `-3` absorbs minor upstream drift. If a
series fails, fix it in that repo and `git am --continue` / `--abort`.

The patches touch six repos:

| repo path in the tree | patches |
|-----------------------|---------|
| `device/zte/fujisan` | 8 |
| `vendor/zte/fujisan` | 2 (zap + FPC blobs) |
| `kernel/zte/msm8996` | 1 |
| `lineage-sdk` | 2 |
| `hardware/qcom-caf/msm8996/audio` | 1 |
| `frameworks/base` | 1 (SystemUI) |

## 3. Build

```bash
export USE_CCACHE=1 CCACHE_EXEC=/usr/bin/ccache   # optional
ccache -M 50G                                      # optional, once
source build/envsetup.sh
lunch lineage_fujisan-userdebug
m bacon
```

Output: `out/target/product/fujisan/lineage-19.1-*-UNOFFICIAL-fujisan.zip`
plus `boot.img` and `recovery.img`.

### Notes

- Build as **userdebug**. The AT&T boot chain is set permissive in V1; the
  tree enables the AOSP boot signer, so `boot.img` gets the BootSignature
  trailer the AT&T bootloader requires.
- The `fujisan_halld` SELinux label warning in `logcat` is harmless while
  permissive. It must be resolved before switching to enforcing (future work).
- `/data` must be **F2FS**. See [FLASHING.md](FLASHING.md).
- Keep the kernel command line at/under ~225 chars. The AT&T bootloader
  panics on a too-long `/chosen` cmdline; this config lands around 279 and
  boots, but trim before adding more.
