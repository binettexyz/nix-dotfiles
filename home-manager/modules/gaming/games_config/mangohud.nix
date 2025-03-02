{ ... }: {

  xdg.configFile."MangoHud/horizontal.conf".text = ''
    fps
    cpu_util
    cpu_temp
    gpu_util
    gpu_temp
    ram
    vram
  
    horizontal
    position=top
    background_alpha=0.3
    font_scale=0.5
  '';

  xdg.configFile."MangoHud/horizontal_minimal.conf".text = ''
    fps
    cpu_util
    gpu_util
    ram

    horizontal
    position=top
    background_alpha=0.3
  '';
}
