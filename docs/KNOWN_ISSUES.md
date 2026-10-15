# Known issues (V1)

## Folded status bar lost its system icons — fixed in V1

**Symptom.** After folding, the status bar showed only the clock and
notification icons; battery, Wi-Fi and signal were missing. Unfolded was fine.

**Cause.** The display itself resizes correctly on every fold (1080×1920
folded, 2160×1915 open). The bug was in SystemUI: A12's
`StatusBarContentInsetsProvider` caches the status bar content area per
*(display id, rotation)* only, and a fold changes neither. The area computed
for the 2160px display (`Rect(24, 0 - 2100, 72)`) was reused on the 1080px
panel, giving a negative right inset that squeezed the system icon area down
to 18px.

**Fix.** `patches/android_frameworks_base/0001` adds the display bounds to the
cache key and drops the cache when the max bounds change (as AOSP does from
Android 13).

## GNSS HAL crash once at boot

`android.hardware.gnss@1.0-service-qti` can SIGSEGV once at boot in
`LocApiV02::setXtraData` (`__memcpy`) — the assisted-GPS XTRA path in the stock
Qualcomm blob. It restarts and does not loop; boot is unaffected. May slow the
first GPS fix. Unrelated to the patches in this repo.
