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
    documents = "$HOME/documents";
    download = "$HOME/downloads";
    pictures = "$HOME/pictures";
    videos = "$HOME/videos";
  };

}
