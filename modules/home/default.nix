{ inputs, pkgs, config, ... }:

{
  home.stateVersion = "22.05";
  imports = [
    (inputs.impermanence + "/home-manager.nix")
    ./packages.nix


    ./cli/git
    ./cli/neovim
    ./cli/tmux
    ./cli/xdg
    ./cli/xresources
    ./cli/zsh

    ./programs/chromium
#    ./programs/discocss
    ./programs/dmenu
    ./programs/librewolf
    ./programs/lf
    ./programs/mpv
#    ./programs/mutt
    ./programs/newsboat
#    ./programs/nnn
    ./programs/powercord
    ./programs/qutebrowser
    ./programs/slstatus
    ./programs/st
#    ./programs/zathura

    ./services/dunst
    ./services/picom
    ./services/flameshot
#    ./services/sxhkd
#    ./services/syncthing
#    ./services/udiskie
  ];

  home.persistence = {
    "/nix/persist/home/binette" = {
      removePrefixDirectory = false;
      allowOther = true;
      directories = [
        ".cache/BraveSoftware"
        ".cache/librewolf"
        ".cache/qutebrowser"

        ".config/BraveSoftware"
        ".config/coc"
        ".config/dunst"
        ".config/git"
        ".config/lf"
        ".config/mpv"
        ".config/mutt"
        ".config/newsboat"
        ".config/nixpkgs"
        ".config/qutebrowser"
        ".config/shell"
        ".config/tremc"
        ".config/x11"

        ".local/bin"
        ".local/share/applications"
        ".local/share/cargo"
        ".local/share/gnupg"
        ".local/share/password-store"
        ".local/share/Ripcord"
        ".local/share/xorg"
        ".local/share/zoxide"
        ".local/share/qutebrowser"

        ".git"
        ".librewolf"
        ".ssh"
        ".gnupg"
        ".zplug"

        "documents"
        "pictures"
        "videos"
        "downloads"
      ];

      files = [
       ".config/pulse/daemon.conf"
        ".config/greenclip.toml"
        ".config/wall.png"
        ".config/zoomus.conf"
        ".config/mimeapps.list"

        ".local/share/history"

        ".cache/greenclip.history"
      ];
    };
  };

}
