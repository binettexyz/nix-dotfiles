{writeShellApplication}:
writeShellApplication {
  name = "clipboard";
  text = ''
    #!/run/current-system/sw/bin/sh
    if ! pgrep wofi > /dev/null; then
      cliphist list | wofi --dmenu | cliphist decode | wl-copy
    fi
  '';
}
