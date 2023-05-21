{ pkgs, ... }:{

  imports = [
    ./cli.nix
    ./git.nix
    ./lf
    ./meta
    ./neovim
    ./ssh.nix
    ./tmux.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
  ];

  xdg.userDirs = {
    enable = true;
    createDirectories = false;
    documents = "$HOME/Documents";
    download = "$HOME/Downloads";
    pictures = "$HOME/Pictures";
    videos = "$HOME/Videos";
  };

}
