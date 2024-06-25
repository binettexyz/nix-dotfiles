{ pkgs, ... }:{

  home.packages = with pkgs; [
    prismlauncher
    heroic
    #grapejuice
    #runescape runelite
    #zeroad
  ];

}

