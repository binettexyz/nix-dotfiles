{ pkgs, ... }:{

  home.stateVersion = "22.05";
  imports = [
    ../modules/device.nix
    ./cli.nix
    ./git.nix
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
