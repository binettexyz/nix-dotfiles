{ pkgs, lib, ... }: {

  services.greenclip.enable = true;
  services.gvfs.enable = lib.mkForce false;

}
