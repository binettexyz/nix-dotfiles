{ config, lib, pkgs, ... }: {

  options.nixos.audio.enable = pkgs.lib.mkDefaultOption "audio config";

  config = lib.mkIf config.nixos.audio.enable {

      # This allows PipeWire to run with realtime privileges (i.e: less cracks)
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      #lowLatency = {
        #enable = true;
        #quantum = 64;
        #rate = 48000;
      #};
    };
  };
}
