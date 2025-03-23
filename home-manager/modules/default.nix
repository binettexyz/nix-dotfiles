{...}: {

  imports = [
    ./chromium.nix
    ./cli.nix
    ./windowManager/dwm
#    ./windowManager/qtile
#    ./gaming
    ./git.nix
    ./lf
    ./librewolf.nix
    ./meta
    ./mpv
    ./neovim
    ./newsboat.nix
    ./pc.nix
    ./qutebrowser
    ./ssh.nix
    ./tmux.nix
    ./zsh.nix
  ];

}
