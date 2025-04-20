#!/usr/bin/env bash

readonly NIXOS=@isNixOS@
AUTO=0
OPTIMIZE=0

usage() {
if [[ "$NIXOS" == 1 ]]; then
    echo "Clean-up NixOS's /nix/store."
else
    echo "Clean-up nix's /nix/store."
fi
    echo
    echo "Usage:"
if [[ "$NIXOS" == 1 ]]; then
    echo "nixos-cleanup [--auto] [--optimize]"
else
    echo "nix-cleanup [--auto] [--optimize]"
fi
    echo
    echo "Arguments:"
    echo "  --auto      Remove auto created gc-roots (e.g.: '/result' symlinks)."
    echo "  --optimize  Run 'nix-store --optimize' afterwards."
    exit 1
}

while [[ "${#:-0}" -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            ;;
        --auto)
            AUTO=1
            shift
            ;;
        --optimize)
            OPTIMIZE=1
            shift
            ;;
        *)
            echo "'$1' is not a recognized flag!"
            exit 1;
            ;;
    esac
done

cleanup() {
    local -r auto="$1"
    local -r nixos="$2"
    local -r optimize="$3"

    if [[ "$auto" == 1 ]]; then
        echo "[INFO] Removing auto created GC roots..."
        find -H /nix/var/nix/gcroots/auto -type l -exec readlink {} \; | \
            grep "/result[-0-9]*$" | \
            xargs -L1 rm -rf
    fi

    echo "[INFO] Verifying nix store..."
    nix-store --verify

    echo "[INFO] Running GC..."
    nix-collect-garbage -d
    if [[ "$nixos" == 1 ]]; then
        echo "[INFO] Rebuilding NixOS to remove old boot entries..."
        nixos-rebuild boot
    fi
    if [[ "$optimize" == 1 ]]; then
        echo "[INFO] Optimizing nix store..."
        nix-store --optimize
    fi
}

if [[ "$NIXOS" == 1 ]]; then
doas bash -c "$(declare -f cleanup); cleanup $AUTO $NIXOS $OPTIMIZE"
else
    cleanup "$AUTO" "$NIXOS" "$OPTIMIZE"
fi
