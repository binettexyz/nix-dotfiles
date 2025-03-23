{ lib, super, ... }: {

  home.file.".config/qtile/config.py".source = lib.mkIf super.services.xserver.windowManager.qtile.enable ./etc/config.py;

}
