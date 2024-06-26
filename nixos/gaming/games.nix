{ pkgs,... }: {

  environment.systemPackages = with pkgs; [
    mindustry
    zeroad
    shattered-pixel-dungeon
  ];

}
