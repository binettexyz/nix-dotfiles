{
  deviceTags,
  lib,
  ...
}: {
  xdg.configFile."MangoHud/horizontal_minimal.conf".text = lib.mkIf (lib.elem "gaming" deviceTags) ''
    fps
    cpu_util
    gpu_util
    ram

    horizontal
    position=top
    background_alpha=0.3
    font_scale=0.5
  '';
}
