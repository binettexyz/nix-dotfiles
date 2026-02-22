{
  flake.nixosModules.sunshine =
    { pkgs, ... }:
    {
      services.sunshine = {
        enable = true;
        autoStart = true;
        openFirewall = false;
        capSysAdmin = true;
        applications = {
          env = {
            PATH = "$(PATH):$(HOME)/.local/bin";
          };
          apps = [
            {
              name = "Desktop";
              image-path = "desktop.png";
            }
            {
              name = "Steam Big Picture";
              output = "steam.txt";
              detached = [
                "${pkgs.util-linux}/bin/setsid ${pkgs.steam}/bin/steam steam://open/bigpicture"
              ];
              image-path = "steam.png";
            }
            {
              name = "MoonDeckStream";
              command = "${pkgs.moondeck-buddy}/bin/MoonDeckStream";
              image-path = "steam.png";
              auto-detach = "false";
              wait-all = "false";
            }
          ];
        };
      };
    };
}
