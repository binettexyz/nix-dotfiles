{ writeShellApplication }:

writeShellApplication {
  name = "screenshot";
  text = ''
    #!/run/current-system/sw/bin/sh
    slurp | grim -g - - | wl-copy
  '';
}
