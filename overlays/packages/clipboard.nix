{ writeShellApplication }:

writeShellApplication {
  name = "clipboard";
  text = ''
    if ! pgrep wofi > /dev/null; then
      cliphist list | wofi --dmenu | cliphist decode | wl-copy
    fi
  '';
}
