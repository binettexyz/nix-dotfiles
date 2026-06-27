{ inputs, ... }:
{
  flake.nixosModules.flatpak =
    { lib, pkgs, ... }:
    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
      services.flatpak.enable = true;
      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdg.portal.config.common.default = lib.mkDefault "gtk";
      environment.sessionVariables = {
        XDG_DATA_DIRS = [
          "/var/lib/flatpak/exports/share"
          "$HOME/.local/share/flatpak/exports/share"
        ];
      };
    };
}
