{ lib, super, ... }: {

  config = lib.mkIf super.services.xserver.windowManager.qtile.enable {
    home.file.".config/qtile/config.py".source = ./etc/config.py;
    

  };
}
