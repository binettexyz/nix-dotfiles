{ writeShellApplication }:
writeShellApplication {
  name = "sysact";
  text = ''
    #!/run/current-system/sw/bin/sh
    if ! pgrep wofi > /dev/null; then
      case "$(printf " Sleep\n Reboot\n Lock\n Shutdown\n Logout" | wofi --dmenu -W 300 -H 200 -i  -p 'Action: ')" in
    	  ' Sleep') systemctl suspend && hyprlock ;;
    	  ' Reboot') systemctl reboot ;;
    	  ' Lock') hyprlock;;
    	  ' Shutdown') systemctl poweroff ;;
        ' Logout') uwsm stop ;;
    	  *) exit 1 ;;
      esac
    fi
  '';
}
