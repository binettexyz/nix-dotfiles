{ writeShellApplication }:

writeShellApplication {
  name = "sysact";
  text = ''
    #!/run/current-system/sw/bin/sh
    if ! pgrep wofi > /dev/null; then
      case "$(printf " Hibernate\n Sleep\n Reboot\nLock\n Shutdown" | wofi --dmenu -W 300 -H 200 -i  -p 'Action: ')" in
    	  ' Hibernate') hyprlock & systemctl hibernate ;;
    	  ' Sleep') systemctl suspend && hyprlock ;;
    	  ' Reboot') systemctl reboot ;;
    	  'Lock') hyprlock;;
    	  ' Shutdown')systemctl poweroff ;;
    	  *) exit 1 ;;
      esac
    fi
  '';
}
