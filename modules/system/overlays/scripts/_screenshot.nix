{ pkgs, writeShellApplication }:
writeShellApplication {
  name = "screenshot";

  runtimeInputs = [
    pkgs.grim
    pkgs.slurp
    pkgs.wl-clipboard
    pkgs.jq
    pkgs.wofi
    pkgs.libnotify
    pkgs.coreutils
    pkgs.wf-recorder
  ];

  text = ''
    #!/run/current-system/sw/bin/sh

    # Ensure directory exists
    mkdir -p "$HOME/pictures/screenshots"
    DEST="$HOME/pictures/screenshots/$(date '+%Y%m%d-%H%M%S').png"

    # Menu
    choice=$(printf "a selected area\ncurrent window\nfull screen\na selected area (copy)\ncurrent window (copy)\nfull screen (copy)" \
        | wofi --dmenu -W 300 -H 270 -i -p 'Screenshot which area? ')

    # Execute
    case "$choice" in
        "selected area") slurp | grim -g - - | tee "$DEST" ;;
        "current window") sleep 0.5 && hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - - | tee "$DEST" ;;
        "full screen") sleep 0.5 && grim "$DEST" ;;
        "selected area (copy)") slurp | grim -g - - | wl-copy ;;
        "current window (copy)") sleep 0.5 && hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - | wl-copy ;;
        "full screen (copy)") sleep 0.5 && grim -g - | wl-copy ;;
    esac
  '';
}
