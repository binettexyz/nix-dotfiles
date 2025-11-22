{ writeShellApplication }:
writeShellApplication {
  name = "screenshot";
  text = ''
    #!/run/current-system/sw/bin/sh
    notification() {
        notify-send -a "Screenshot" -u low ' Screenshot' "Saved to $HOME/pictures/screenshots"
    }
    notificationClip() {
        notify-send -a "Screenshot" -u low ' Screenshot' "Saved to clipboard"
    }

    case "$(printf "a selected area\\ncurrent window\\nfull screen\\na selected area (copy)\\ncurrent window (copy)\\nfull screen (copy)" | wofi --dmenu -W 300 -H 270 -i -p 'Screenshot which area? ')" in
            "a selected area") slurp | grim -g - - | tee ~/pictures/screenshots/pic-selected-"$(date '+%Y%m%d-%Hh%Mm%Ss').png" && notification ;;
            "current window") sleep 0.5 && hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - - | tee ~/pictures/screenshots/pic-window-"$(date '+%Y%m%d-%Hh%Mm%Ss').png" && notification ;;
            "full screen") sleep 0.5 && grim ~/pictures/screenshots/pic-full-"$(date '+%Y%m%d-%Hh%Mm%Ss').png" && notification ;;
            "a selected area (copy)") slurp | grim -g - - | wl-copy && notificationClip ;;
            "current window (copy)") sleep 0.5 && hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - | wl-copy && notificationClip ;;
            "full screen (copy)") sleep 0.5 && grim - | wl-copy && notificationClip ;;
    esac
  '';
}
