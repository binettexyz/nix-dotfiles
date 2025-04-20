{ writeShellApplication }:

writeShellApplication {
  name = "wofirun";
  text = ''
    #!/run/current-system/sw/bin/sh
    wofi -W 500 -H 300 --show run
  '';
}
