{ ... }:
{

  imports = [
    ./meta
    ./packages.nix
    ./dotfiles/browsers/chromium.nix
    ./dotfiles/browsers/librewolf.nix
    ./dotfiles/browsers/qutebrowser
    ./dotfiles/desktopEnvironment/plasma-manager.nix
    ./dotfiles/desktopEnvironment/qtile
    ./dotfiles/media/mpv
    ./dotfiles/media/newsboat.nix
    ./dotfiles/shells/zsh.nix
    ./dotfiles/terminals/foot.nix
    ./dotfiles/textEditors/emacs
    ./dotfiles/textEditors/helix.nix
    ./dotfiles/textEditors/neovim
    ./dotfiles/tools/git.nix
    ./dotfiles/tools/lf
    ./dotfiles/tools/ssh.nix
    ./dotfiles/tools/tmux.nix
  ];

}
