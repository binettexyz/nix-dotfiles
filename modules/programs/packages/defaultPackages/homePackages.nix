{
  flake.modules.homeManager.defaultpackages =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config.home.packages = lib.mkMerge [
        [
          #          pkgs.bat
          #          pkgs.cron
          #          pkgs.curl
          #          pkgs.eza
          #          pkgs.fzf
          #          pkgs.gcc
          #          pkgs.gnused
          #          pkgs.htop
          #      pkgs.killall
          #      pkgs.ncdu
          #      pkgs.ouch # easily compressing and decompressing files and directories

          pkgs.capitaine-cursors-themed
        ]

        (lib.mkIf (lib.elem "workstation" config.modules.device.tags) [
          # https://wiki.archlinux.org/title/Discord#Mic_volume_keeps_lowering_when_Discord_is_active_using_Wireplumber
          pkgs.vesktop
        ])

        (lib.mkIf (lib.elem "dev" config.modules.device.tags) [
          pkgs.libreoffice
          pkgs.texlive.combined.scheme-full
          #          pkgs.xfce.thunar
          pkgs.calibre
        ])
      ];
    };
}
