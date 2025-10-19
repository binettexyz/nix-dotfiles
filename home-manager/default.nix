{
  config,
  flake,
  lib,
  ...
}: {
  imports =
    [
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
      ./meta
      ./packages.nix
      ./pc.nix
      ./theme.nix
      ../modules/custom
      ../modules/custom/colorScheme.nix
      (flake.inputs.impermanence + "/home-manager.nix")
      flake.inputs.nix-colors.homeManagerModule
      flake.inputs.plasma-manager.homeModules.plasma-manager
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
