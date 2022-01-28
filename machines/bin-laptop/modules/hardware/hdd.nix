{ lib, ... }:

{

    # swap ram when % bellow is reach (1-100)
  boot.kernel.sysctl = {
    "vm.swappiness" = lib.mkDefault 10;
  };

    # Hard disk protection if the laptop falls
  services.hdapsd.enable = lib.mkDefault true;
}
