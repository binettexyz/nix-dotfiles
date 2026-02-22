{
  flake.modules.homeManager.qtile =
    {
      lib,
      ...
    }:
    {
      home.file.".config/qtile/config.py".source = ./src/config.py;
      home.file.".config/qtile/autostart.sh" = {
        source = ./src/autostart.sh;
        executable = true;
      };
    };
}
