{ flake, ... }:
let
  inherit (flake) inputs;
in
{

  imports = [
    ../../home-manager
    (inputs.impermanence + "/home-manager.nix")
    flake.inputs.nix-colors.homeManagerModule
    #    flake.inputs.nixvim.homeManagerModules.nixvim
  ];

  colorScheme = import ../../modules/colorSchemes/gruvbox-material.nix;

  modules.hm = {
    browser.librewolf.enable = true;
    browser.qutebrowser.enable = true;
    mpv = {
      enable = true;
      lowSpec = true;
    };
  };

  # ---Persistence---
  home.persistence."/nix/persist/home/binette" = {
    removePrefixDirectory = false;
    allowOther = true;
    directories = [
      ".cache/BraveSoftware"
      #".cache/Jellyfin Media Player"
      ".cache/librewolf"
      ".cache/qutebrowser"

      #".config/BraveSoftware"
      #".config/jellyfin.org"
      ".config/qtile"
      ".config/shell"
      ".config/sops"

      ".local/bin"
      ".local/share/applications"
      ".local/share/cargo"
      ".local/share/gnupg"
      #".local/share/jellyfinmediaplayer"
      #".local/share/Jellyfin Media Player"
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
      ".config/greenclip.toml"
      ".config/wall.png"
      #".config/zoomus.conf"
      ".local/share/history"
      ".cache/greenclip.history"
    ];
  };

}
