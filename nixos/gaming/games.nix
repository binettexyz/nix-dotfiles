{ pkgs,... }:

let
  ports = {
    mindustry = 6567;
    factorio = 6566;
  };

in {

  networking.firewall.allowedTCPPorts = [
    ports.mindustry
    ports.factorio
  ];
  networking.firewall.allowedUDPPorts = [
    ports.mindustry
    ports.factorio
  ];

  environment.systemPackages = with pkgs; [
    zeroad
    shattered-pixel-dungeon
  ];

}
