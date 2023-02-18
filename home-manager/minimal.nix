{ pkgs, ... }:{

  home.stateVersion = "22.05";
  imports = [
    ./cli.nix
    #./git.nix
    ./neovim.nix
    #./ssh
    #./tmux.nix
    #./zsh.nix
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