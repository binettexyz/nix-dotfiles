{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    userName = "Jonathan Binette";
    userEmail = "binettexyz@proton.me";

    delta = {
      enable = true;
      options = {
        features = "line-numbers decorations";
        syntax-theme = "ansi";
        #plus-style = ''syntax "#003800"'';
        #minus-style = ''syntax "#3f0001"'';
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-style = "bold yellow ul";
          file-decoration-style = "none";
          hunk-header-decoration-style = "cyan box ul";
        };
        delta = {
          navigate = true;
        };
        line-numbers = {
          line-numbers-left-style = "cyan";
          line-numbers-right-style = "cyan";
          line-numbers-minus-style = 124;
          line-numbers-plus-style = 28;
        };
      };
    };

    ignores = [
    ];

    extraConfig = {
      init = {
        defaultBranch = "master";
      };
      branch = {
        sort = "-committerdate";
      };
      color = {
        ui = true;
      };
      commit = {
        verbose = true;
      };
      core = {
        editor = "nvim";
        #whitespace = "trailing-space,space-before-tab,indent-with-non-tab";
      };
      checkout = {
        defaultRemote = "origin";
      };
      github = {
        user = "binettexyz";
      };
      merge = {
        conflictstyle = "zdiff3";
        tool = "nvim -d";
      };
      #pull = { rebase = true; };
      push = {
        autoSetupRemote = true;
        default = "simple";
      };
      #rebase = { autoStash = true; };
      safe.directory = [
        "/etc/nixos"
        "/nix/persist/etc/nixos"
      ];
    };

    aliases = {
      co = "checkout";
      fuck = "commit --amend -m";
      c = "commit -m";
      ca = "commit -am";
      forgot = "commit --amend --no-edit";
      graph = "log --all --decorate --graph --oneline";
      addup = "add -u";
      rev = "ls-remote";
      l = "log";
      r = "rebase";
      s = "status --short";
      ss = "status";
      d = "diff";
      br = "branch";
    };
  };
}
