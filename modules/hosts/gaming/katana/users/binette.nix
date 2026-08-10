{ inputs, ... }:
let
  host = "katana";
in
{
  flake.modules.homeManager."${host}Binette" =
    {
      lib,
      config,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [
        binetteShell
        binetteLibrewolf
        binetteMpv
        binetteYazi
        binetteNeovim
        binetteFoot
        binetteGit
        binetteTmux
        minimalPreset
        emulation
        gaming
      ];

      modules = {
        device = {
          hostname = host;
          type = "console";
          tags = [
            "console"
            "workstation"
            "highSpec"
          ];
          videoOutputs = [
            "DP-1"
          ];
          storage = {
            hdd = true;
            ssd = true;
          };
        };
      };
    };
}
