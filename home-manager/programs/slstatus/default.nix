{ pkgs, config, lib, inputs, ... }:
with lib;

let
  cfg = config.modules.programs.slstatus;
  slstatus-laptop = pkgs.callPackage (inputs.slstatus-laptop + "/default.nix") {};
  slstatus-desktop = pkgs.callPackage (inputs.slstatus-desktop + "/default.nix") {};
in
{
  options.modules.programs.slstatus = mkOption {
      description = "Enable slstatus bar";
      type = with types; nullOr (enum [ "desktop" "laptop" ]);
      default = null;
  };

  config = mkMerge [
    (mkIf (cfg == "laptop") {
      home.packages = with pkgs; [ slstatus-laptop ];
    })
    (mkIf (cfg == "desktop") {
      home.packages = with pkgs; [ slstatus-desktop ];
    })
  ];


}
