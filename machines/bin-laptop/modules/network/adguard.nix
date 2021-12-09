{ lib, ... }: {

  services.adguardhome = {
    enable = false;
    openFirewall = true;
  };
}
