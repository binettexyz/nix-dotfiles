{
  flake.nixosModules.moondeck =
    { pkgs, ... }:
    {
      systemd.user.services.moondeck-buddy = {
        enable = true;
        unitConfig = {
          Description = "MoonDeckBuddy";
          After = [ "graphical-session.target" ];
        };
        serviceConfig = {
          ExecStart = "${pkgs.moondeck-buddy}/bin/MoonDeckBuddy";
          Restart = "on-failure";
        };
        wantedBy = [ "graphical-session.target" ];
      };
    };
}
