{ pkgs, config, lib, inputs, ... }:
with lib;

let
  cfg = config.modules.programs.terminal;
  st-head = pkgs.callPackage (inputs.st + "/default.nix") {};
in
{
  options.modules.programs.terminal = mkOption {
      description = "Choose terminal emulator";
      type = with types; nullOr (enum [ "st" "xterm" ]);
      default = "xterm";
    };

  config = mkMerge [
    (mkIf (cfg == "st") {
      home.packages = with pkgs; [ st-head ];
    })
    (mkIf (cfg == "xterm") {
      home.packages = with pkgs; [ xterm ];
    })
  ];

}
