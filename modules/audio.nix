{ config, pkgs, ... }: {

        imports = [
                ./pipewireLowLatency.nix
        ];

        services.pipewire = {
                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
                  # If you want to use JACK applications, uncomment this
                # jack.enable = true;
                lowLatency = {
                        enable = true;
                        quantum = 64;
                        rate = 48000;
                };
        };
          # make pipewire realtime-capable
        security.rtkit.enable = true;

}
