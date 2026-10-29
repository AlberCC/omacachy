# 051 — Preserved CachyOS installation mode

Base: `b46236a8e6d4c1c63b182b73a63f956aee2c3ef0`, 2026-10-29.

The user authorized preparing installation after a read-only audit. This
session cannot reuse their terminal's sudo authorization; provide a tested
terminal-driven procedure.

## Evidence

Stable currently advertises omarchy and omarchy-settings 4.0.6-1. Downloaded
to `/tmp`, not installed; hashes match the HTTPS repository database:

- omarchy: `b314f137fc0af8c0e7293b7e716f655964e888b8277ec253dc96d13a7c2538a9`
- settings: `19ad3ff0cfad10b8dd11fb2d0cb08c55987634ff3e57f3af4e5a9b43f78e9cca`

This does not replace pacman's signature validation. Inspected scriptlets,
apply-system/hardware, stage dispatch, NVIDIA, Snapper, pacman reset, user
provisioning and Limine refresh. Upstream still requests NVIDIA DKMS.

## Changes and checks

Opt-in `--preserve-cachyos`: mandatory snapshot on each run without cleanup;
boot/desktop copies; persistent stack/version barriers and EFI hook inhibition;
staged apply preserving NVIDIA/Snapper/pacman and deferring SDDM. Preserve
chwd's captured omission of kms. Check actual initramfs cryptsetup contents
and per-kernel NVIDIA module availability after rebuilding.

Always back up removed sddm.conf; restore pacman config after apply failure;
remove redundant post-apply `pacman -Sy`.

The new mode deliberately differs from plan 045's non-blocking snapshot policy.
Baseline: 307 passed, one missing-ShellCheck failure. Downloaded official
ShellCheck 0.11.0 to `/tmp`, without installing packages. Added fixture tests
for Snapper failures/malformed output, version drift, package denials, staged
tree isolation, EFI hook suppression and GPU dispatch.

No host pacman transaction, initramfs rebuild, service change or reboot was
executed. End-to-end hardware and recovery validation remain gates. Package
guards do not cover arbitrary future scripts or manual local packages.

Operator procedure: `docs/install-cachyos-preserved.md`.

The stage helper was also exercised on the extracted 4.0.6-1 install tree:
only the four intended files differ; no upstream scripts were executed.

First operator attempt stopped at pacman's file-conflict check: five skel
files were owned by cachyos-hypr-noctalia/cachyos-alacritty-config. No packages
were upgraded; snapshot 11 and recovery copies exist. The installed Noctalia
preset has no removal scriptlet and no reverse dependents; alacritty's preset
is required only by that preset. Added non-recursive removal of those presets
after backing up skel and preserving their greeter/profile files outside skel.
Do not use --overwrite for package-owned collisions. Runtime packages stay.

Second operator attempt installed Omarchy/settings and base applications and
completed staged apply-system. Seeding then aborted because its old top-level
backup copied all of ~/.local, reaching the root-only recovery archives.
Replace that backup with an enumeration of skel leaf paths, preserving only
existing collisions (including dangling symlinks). Regression tests use an
unreadable recovery archive and assert it is neither copied nor chmod'ed.
The logged luarocks-admin error preceded the luarocks install; the subsequent
scriptlet built the 5.1 manifest, and the executable is now package-owned.

Final operator run completed with 19 PASS and 0 FAIL. On 2026-10-29 the
operator confirmed a successful reboot and desktop login on the preserved
CachyOS installation with LUKS and NVIDIA RTX 3060. This supersedes the
pre-install status above; recovery, LTS boot and future upgrades remain
unverified. SDDM autologin was configured separately as a local preference
and is not part of this change.
