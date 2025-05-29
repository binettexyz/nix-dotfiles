{
  deviceType,
  lib,
  ...
}: {
  imports =
    [
      ./meta
      ../modules/colorSchemes
      ./packages.nix
      ./pc.nix
      ./dotfiles/browsers/chromium.nix
      ./dotfiles/browsers/librewolf.nix
      ./dotfiles/browsers/qutebrowser
      ./dotfiles/desktopEnvironment/hyprland
      ./dotfiles/desktopEnvironment/plasma-manager.nix
      ./dotfiles/desktopEnvironment/qtile
      ./dotfiles/media/mpv
      ./dotfiles/media/newsboat.nix
      ./dotfiles/shells
      ./dotfiles/terminals/foot.nix
      ./dotfiles/textEditors/helix.nix
      ./dotfiles/textEditors/neovim
      ./dotfiles/tools/git.nix
      ./dotfiles/tools/ssh.nix
      ./dotfiles/tools/tmux.nix
      ./dotfiles/tools/yazi.nix
    ]
    ++ lib.optional (deviceType != "server") ./theme.nix;

  options = {
    modules.hm.gaming = {
      enable = lib.mkOption {
        description = "Enable gaming related configuration";
        default = false;
      };
    };
    modules.hm.gui.packages = lib.mkOption {
      description = "Install gui packages";
      default = false;
    };
  };
}
