{ config, pkgs, ... }: {

  imports = [
    ./pipewireLowLatency.nix
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    lowLatency = {
      enable = true;
      quantum = 64;
      rate = 48000;
    };
      # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };
    # make pipewire realtime-capable
  security.rtkit.enable = true;

}
