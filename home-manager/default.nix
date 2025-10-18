{
  config,
  inputs,
  lib,
  ...
}: {
  imports =
    [
      ../modules/custom/colorSchemes
      ../modules/custom
      ../overlays
      ./meta
      ./theme.nix
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
      (inputs.impermanence + "/home-manager.nix")
      inputs.nix-colors.homeManagerModule
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];

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
