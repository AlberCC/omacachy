# shellcheck shell=bash
# Rendered policies are deliberately independent of Omarchy's update wrappers.
# A future migration must fail visibly instead of replacing the host kernel.
render_cachyos_package_guard() {
    cat <<'EOF'
#!/bin/bash
set -euo pipefail
while IFS= read -r package; do
    case "$package" in
        omarchy|omarchy-settings)
            version="$(LC_ALL=C pacman -Si "$package" | awk '$1 == "Version" {print $3}')" || exit 1
            if [[ $version != 4.0.6-1 ]]; then
                echo "omacachy: $package candidate $version has not been reviewed; preservation mode requires 4.0.6-1." >&2
                exit 1
            fi
            ;;
        linux|linux-headers|linux-lts|linux-lts-headers|linux-zen|linux-zen-headers|linux-hardened|linux-hardened-headers|linux-omarchy*|linux-t2*|nvidia|nvidia-open|nvidia-dkms|nvidia-open-dkms|nvidia-[0-9]*xx*)
            echo "omacachy: refusing $package; CachyOS owns the kernel and NVIDIA modules. Review this migration manually." >&2
            exit 1
            ;;
    esac
done
EOF
}

# Do not hide a failed Snapper command behind tail, or accept its diagnostics
# as an ID. Used outside a pipeline so the caller can abort before mutation.
create_install_snapshot() {
    local number
    number="$(run_root snapper --no-dbus -c root create \
        --description 'before omacachy install' --print-number)" || return 1
    [[ $number =~ ^[1-9][0-9]*$ ]] || {
        echo 'Error: Snapper did not return a valid snapshot number.' >&2
        return 1
    }
    printf '%s\n' "$number"
}

# Operates only on a disposable copy of the installed package's install tree.
# The caller creates this directory as root, with mode 0700.
stage_cachyos_install_tree() {
    local source_dir="$1" target_dir="$2"
    local relative
    for relative in hardware/nvidia.sh config/snapper.sh post-install/pacman.sh config/enable-services.sh; do
        [[ -f $source_dir/$relative && ! -L $source_dir/$relative ]] || {
            echo "Error: unsupported Omarchy install layout: $relative" >&2
            return 1
        }
    done
    # Refuse drift rather than guessing how a future service stage works.
    [[ $(grep -cxF 'systemctl enable sddm.service' "$source_dir/config/enable-services.sh") == 1 ]] || return 1
    cp -a "$source_dir/." "$target_dir/" || return 1
    chmod 700 "$target_dir" || return 1
    for relative in hardware/nvidia.sh config/snapper.sh post-install/pacman.sh; do
        printf 'echo "omacachy: preserving CachyOS %s"\n' "$relative" >"$target_dir/$relative" || return 1
    done
    sed -i '/^systemctl enable sddm\.service$/d' "$target_dir/config/enable-services.sh"
}

# /etc/skel is merged into HOME, not substituted wholesale. Back up only
# existing leaf paths it supplies, rather than all of ~/.local and ~/.config.
# In particular, recovery archives under ~/.local/state can be root-only and
# must never be traversed, chmod'ed or recursively copied by this user step.
backup_skel_collisions() {
    local skel_dir="$1" user_home="$2" backup_dir="$3" relative
    (umask 077; mkdir -p "$backup_dir") || return 1
    find "$skel_dir" -mindepth 1 ! -type d -printf '%P\0' >"$backup_dir/skel-paths.nul" || return 1
    while IFS= read -r -d '' relative; do
        if [[ -e $user_home/$relative || -L $user_home/$relative ]]; then
            mkdir -p "$backup_dir/$(dirname "$relative")" || return 1
            cp -a -- "$user_home/$relative" "$backup_dir/$relative" || return 1
        fi
    done <"$backup_dir/skel-paths.nul"
}
