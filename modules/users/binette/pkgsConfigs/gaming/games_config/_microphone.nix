{ config, lib, ... }:
{
  # https://www.reddit.com/r/archlinux/comments/190dvl8/pipewirewayland_how_to_stop_applications_from/
  # https://askubuntu.com/questions/279407/how-to-disable-microphone-from-auto-adjusting-its-input-volume
  xdg.configFile."pipewire/pipewire-pulse.conf.d/99-stop-microphone-auto-adjust.conf".text =
    lib.mkIf (lib.elem "gaming" config.device.tags) ''
      access.rules = [
      {
          matches = [
                 { application.process.binary = "chrome" }
                 { application.process.binary = "Discord" }
                 { application.process.binary = "Vesktop" }
                 { application.process.binary = "Chromium" }
            ]
          actions = { update-props = { default_permissions = "rx" } }
        }
      ]
    '';
}
