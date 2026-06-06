{ inputs, ... }:
{
  flake.nixosModules.flatpak =
    { pkgs, ... }:
    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
      services.flatpak.enable = true;
      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdg.portal.config.common.default = "gtk";
      environment.sessionVariables = {
        XDG_DATA_DIRS = [
          "/var/lib/flatpak/exports/share"
          "$HOME/.local/share/flatpak/exports/share"
        ];
      };
    };
}
