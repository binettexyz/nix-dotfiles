{ writeShellApplication }:

writeShellApplication {
  name = "screenshot";
  text = ''
    slurp | grim -g - - | wl-copy
  '';
}
