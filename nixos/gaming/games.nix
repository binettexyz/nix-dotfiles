{ pkgs,... }: {

  environment.systemPackages = with pkgs; [
    mindustry
    zeroad
    freeciv
    shattered-pixel-dungeon
    xonotic
  ];

}
