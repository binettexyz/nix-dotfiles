{ pkgs, ... }:
{

  imports = [
    ./zsh.nix
  ];

  home.shellAliases = {
    nixsh = "nix-shell -p";
    nixup = "pushd /etc/nixos; doas nix flake update; popd";
    nixq = "nix-store -q --requisites /run/current-system/sw | wc -l";
    cleanup = "doas nix-collect-garbage -d";
    bloat = "nix path-info -Sh /run/current-system";
    nixhost = "pushd /etc/nixos; doas nixos-rebuild switch --flake .# --build-host desktop-server";

    # Naviguation
    ".." = "cd ..";
    "..." = "cd ../..";
    ".3" = "cd ../../..";
    ".4" = "cd ../../../..";
    ".5" = "cd ../../../../..";

    # Custom packages script
    lf = "lfrun";
    ncdu = "${pkgs.dua}/bin/dua interactive";

    # clipboard
    #c = "${pkgs.xclip}/bin/xclip";
    #cm = "${pkgs.xclip}/bin/xclip -selection clipboard";
    #v = "${pkgs.xclip}/bin/xclip -o";

    # confirm before overwriting something
    cp = "cp -riv";
    mv = "mv -iv";
    rm = "rm -rifv";
    mkdir = "mkdir -pv";

    # colorize
    ls = "${pkgs.eza}/bin/eza -hal --color=always --group-directories-first -s extension";
    cat = "${pkgs.bat}/bin/bat --paging=never --style=plain";
    tree = "${pkgs.eza}/bin/eza --tree --icons";
    diff = "diff --color=auto";
    ip = "ip --color=auto";

    # Adding flags
    df = "df -h";
    free = "free -m";
    jctl = "journalctl -p 3 -xb";

    emacst = "${pkgs.emacs}/bin/emacsclient -nw ''";
    emacs = "${pkgs.emacs}/bin/emacsclient -c -a 'emacs'";
    em = "${pkgs.emacs}/bin/emacs -nw";

    # git
    addup = "git add -u";
    addall = "git add .";
    branch = "git branch";
    checkout = "git checkout";
    clone = "git clone";
    commit = "git commit -m";
    fetch = "git fetch";
    pull = "git pull origin";
    push = "git push origin";
    status = "git status";
    tag = "git tag";
    newtag = "git tag -a";
    subadd = "git submodule add";
    subup = "git submodule update --remote --merge";

    # fetch computer specs
    pfetch = "curl -s https://raw.githubusercontent.com/dylanaraps/pfetch/master/pfetch | sh";
  };

}
