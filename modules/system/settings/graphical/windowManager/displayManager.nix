{ inputs, ... }:
{
  flake.nixosModules.displayManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.modules.desktopEnvironment;
      command =
        {
          qtile =
            "${pkgs.tuigreet}/bin/tuigreet"
            + "-t -r"
            + "--cmd '${pkgs.python312Packages.qtile}/bin/qtile start -b wayland'";
          hyprland-uwsm = "${pkgs.tuigreet}/bin/tuigreet --asterisks -t -r -c 'uwsm start hyprland-uwsm.desktop'";
          plasma = "${pkgs.tuigreet}/bin/tuigreet -t -r --cmd startplasma-wayland";
        }
        .${cfg};
    in
    {
      imports = with inputs.self.nixosModules; [
        hyprland
        qtile
        plasma
        dmOptions
      ];
      config = {
        services.greetd.enable = lib.mkIf (!(lib.elem "console" config.modules.device.tags)) true;
        services.greetd.settings.default_session =
          lib.mkIf (!(lib.elem "console" config.modules.device.tags))
            {
              user = config.meta.username;
              command = command;
            };
      };
    };
}
