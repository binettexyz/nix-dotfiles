{ config, lib, pkgs, ... }:

{
  options.nixos.desktop.enable = lib.mkEnableOption "desktop config" // { default = (config.device.type == "desktop"); };

  config = lib.mkIf config.nixos.desktop.enable {

  };

}
