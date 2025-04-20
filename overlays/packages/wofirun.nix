{ writeShellApplication }:

writeShellApplication {
  name = "wofirun";
  text = ''
    wofi -W 500 -H 300 --show run
  '';
}
