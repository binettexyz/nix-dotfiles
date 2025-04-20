{
  config,
  lib,
  flake,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.modules.system.audio.enable;
in
{

  imports = [ flake.inputs.nix-gaming.nixosModules.pipewireLowLatency ];

  options.modules.system.audio.enable = mkOption {
    description = "audio config";
    default = false;
  };

  config = lib.mkIf config.modules.system.audio.enable {
    # This allows PipeWire to run with realtime privileges (i.e: less cracks)
    security.rtkit.enable = true;

    services.pipewire = {
      enable = lib.mkDefault true;
      audio.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      lowLatency = {
        enable = true;
        quantum = 64;
        rate = 48000;
      };
    };
  };

}
