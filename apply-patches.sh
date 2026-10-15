#!/usr/bin/env bash
# Apply the fujisan AT&T LineageOS 19.1 patch series onto an Android source tree.
# Usage: apply-patches.sh /path/to/android-source
set -euo pipefail

SRC="${1:-}"
if [ -z "$SRC" ] || [ ! -d "$SRC/.repo" ]; then
    echo "usage: $0 /path/to/android-source   (the repo root with .repo/)" >&2
    exit 1
fi

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCHES="$HERE/patches"

# patch-folder  ->  path within the Android source tree
declare -A MAP=(
    [android_device_zte_fujisan]="device/zte/fujisan"
    [android_vendor_zte_fujisan]="vendor/zte/fujisan"
    [android_kernel_zte_msm8996]="kernel/zte/msm8996"
    [lineage-sdk]="lineage-sdk"
    [hardware_qcom-caf_msm8996_audio]="hardware/qcom-caf/msm8996/audio"
)

for folder in "${!MAP[@]}"; do
    dst="$SRC/${MAP[$folder]}"
    series=("$PATCHES/$folder"/*.patch)
    if [ ! -d "$dst" ]; then
        echo "!! missing $dst — sync the tree first (see docs/BUILDING.md)" >&2
        exit 1
    fi
    echo "== ${MAP[$folder]}: applying ${#series[@]} patch(es)"
    ( cd "$dst" && git am -3 "${series[@]}" ) || {
        echo "!! git am failed in ${MAP[$folder]}; resolve then 'git am --continue' (or --abort)" >&2
        exit 1
    }
done

echo "All patch series applied."
