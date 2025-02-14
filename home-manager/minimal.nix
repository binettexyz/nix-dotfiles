{ pkgs, ... }:{

  imports = [
    ./modules/cli.nix
    ./modules/git.nix
    ./modules/lf
    ./modules/meta
    ./modules/neovim
    ./modules/ssh.nix
    ./modules/tmux.nix
    ./modules/zsh.nix
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
