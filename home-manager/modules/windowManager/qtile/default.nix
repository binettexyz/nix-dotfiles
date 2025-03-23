{ ... }: {

  home.file.".config/qtile/config.py".source = lib.mkIf super.services.xserver.qtile.enable ./etc/config.py;

}
