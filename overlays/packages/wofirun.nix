{ writeShellApplication }:

writeShellApplication {
  name = "wofirun";
  text = ''
    #!/run/current-system/sw/bin/sh
    if ! pgrep wofi > /dev/null; then
      wofi -W 500 -H 300 --show run
    fi
  '';
}
