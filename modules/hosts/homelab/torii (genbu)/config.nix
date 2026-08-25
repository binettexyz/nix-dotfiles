{ inputs, ... }:
let
  host = "torii";
  system = "aarch64-linux";
in
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos system host;
  flake.nixosModules.${host} = {
    imports = with inputs.self.nixosModules; [
      binette
      home-manager
      homelabPreset
    ];

    modules = {
      bootloader.default = "rpi4";
      device = {
        cpu = "";
        hostname = host;
        #network.ipv4 = {
        #  internal = "192.168.2.17";
        #  tailscale = "100.110.153.50";
        #};
        storage.hdd = true;
        type = "server";
      };
    };
  };
}
