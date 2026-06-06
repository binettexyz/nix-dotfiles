{
  flake.modules.homeManager.hyprGamemode =
    { pkgs, ... }:
    let
      gamemode = pkgs.writeShellScriptBin "gamemode" ''
        HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
        if [ "$HYPRGAMEMODE" = 1 ] ; then
            hyprctl --batch "\
                keyword animations:enabled 0;\
                keyword decoration:shadow:enabled 0;\
                keyword decoration:blur:enabled 0"
            hyprctl notify 1 5000 "rgb(40a02b)" "Gamemode [ON]"
        else
            hyprctl notify 1 5000 "rgb(d20f39)" "Gamemode [OFF]"
            hyprctl reload
        fi
      '';
    in
    {

      # https://www.reddit.com/r/linux_gaming/comments/1rlnhhz/comment/o8t9xqq/
      # One thing that hyprland does stupidly is it doesn't enable direct scanout by default.
      # If your games feel less smooth than on other DEs that's why, add render {direct_scanout=1} to your config
      wayland.windowManager.hyprland.settings = {
        render = {
          direct_scanout = 1;
        };
        bind = [
          "$mod1, G, exec, ${gamemode}/bin/gamemode"
        ];
      };
    };
}
