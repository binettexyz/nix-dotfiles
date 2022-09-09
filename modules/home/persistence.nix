{ pkgs, lib, config, inputs, ... }:
with lib;

let 
  cfg = config.modules.impermanence;
in {

  imports = [ (inputs.impermanence + "/home-manager.nix") ];

  options.modules.impermanence = {
    enable = mkOption {
      description = "Enable impermanence";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    ({
      home.persistence = {
        "/nix/persist/home/binette" = {
          removePrefixDirectory = false;
          allowOther = true;
          directories = [
            ".cache/BraveSoftware"
#            ".cache/Jellyfin Media Player"
            ".cache/librewolf"
            ".cache/qutebrowser"
      
            ".config/BraveSoftware"
#            ".config/jellyfin.org"
            ".config/mutt"
#            ".config/nixpkgs"
            ".config/shell"
            ".config/tremc"
      
            ".local/bin"
            ".local/share/applications"
            ".local/share/cargo"
            ".local/share/gnupg"
#            ".local/share/jellyfinmediaplayer"
#            ".local/share/Jellyfin Media Player"
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
    })
  ]);

}

