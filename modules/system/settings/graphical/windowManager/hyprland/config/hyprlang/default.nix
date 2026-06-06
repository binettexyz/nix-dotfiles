{ inputs, ... }:
{
  flake.modules.homeManager.hyprDefault = {
    imports = with inputs.self.modules.homeManager; [
      hyprGeneral
      hyprKeybinds
      hyprGamemode
      hyprMisc
      hyprAnimations
      hyprExec
      hyprInputs
      hyprMonitors
      hyprWorkspaces
    ];
  };
}
