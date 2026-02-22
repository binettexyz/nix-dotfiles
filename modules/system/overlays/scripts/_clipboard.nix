{ pkgs, writeShellApplication }:
writeShellApplication {
  name = "clipboard";

  runtimeInputs = [
    pkgs.procps
    pkgs.cliphist
    pkgs.wl-clipboard
    pkgs.wofi
  ];

  text = ''
    #!/run/current-system/sw/bin/sh
    pkill wofi 2>/dev/null || true
    cliphist list | wofi --dmenu | cliphist decode | wl-copy
  '';
}
