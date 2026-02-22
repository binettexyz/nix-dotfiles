{ inputs, ... }:
{

  flake.nixosModules.fonts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

      #environment.systemPackages = [pkgs.faba-mono-icons];

      fonts = {
        fontDir.enable = true;

        enableDefaultPackages = true;
        packages = [
          pkgs.lmodern
          pkgs.font-awesome
          pkgs.noto-fonts-color-emoji
          pkgs.material-design-icons
          pkgs.nerd-fonts.fantasque-sans-mono
          pkgs.nerd-fonts.jetbrains-mono
        ];

        fontconfig = {
          enable = true;
          includeUserConf = true;
          cache32Bit = true;
          defaultFonts = {
            emoji = [ "Noto Color Emoji" ];
            serif = [ "JetBrainsMono Nerd Font" ];
            sansSerif = [ "JetBrainsMono Nerd Font" ];
            monospace = [ "FantasqueSansMono Nerd Font mono" ];
          };
        };
      };
    };
}
