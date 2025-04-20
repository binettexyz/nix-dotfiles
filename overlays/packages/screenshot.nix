{ writeShellApplication }:

writeShellApplication {
  name = "screenshot";
  text = ''
    #!/run/current-system/sw/bin/sh
    case "$(printf "a selected area\\ncurrent window\\nfull screen\\na selected area (copy)\\ncurrent window (copy)\\nfull screen (copy)" | wofi --dmenu -W 300 -H 270 -i -p 'Screenshot which area? ')" in
            "a selected area") slurp | grim -g - - | tee ~/pictures/screenshots/pic-selected-"$(date '+%Y%m%d-%Hh%Mm%Ss').png" && notify-send 'MAIM' 'pic-selected screenshot saved' ;;
            "current window") hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - - | tee ~/pictures/screenshots/pic-window-"$(date '+%Y%m%d-%Hh%Mm%Ss').png" && notify-send 'MAIM' 'pic-window screenshot saved' ;;
            "full screen") grim ~/pictures/screenshots/pic-full-"$(date '+%Y%m%d-%Hh%Mm%Ss').png" && notify-send 'MAIM' 'pic-full screenshot saved' ;;
            "a selected area (copy)") slurp | grim -g - - | wl-copy && notify-send 'MAIM' 'pre-selected screenshot saved in clipboard' ;;
            "current window (copy)") hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - | wl-copy && notify-send 'MAIM' 'pic-window screenshot saved in clipboard' ;;
            "full screen (copy)") grim - | wl-copy && notify-send 'MAIM' 'pic-full screenshot saved in clipboard' ;;
    esac
  '';
}
