{flake, ...}:
{
  imports = [
    ../../home-manager
    (flake.inputs.impermanence + "/home-manager.nix")
    flake.inputs.nix-colors.homeManagerModule
    flake.inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  colorScheme = import ../../modules/colorSchemes/gruvbox-material.nix;

#  home.persistence = {
#    "/nix/persist/home/binette" = {
#      removePrefixDirectory = false;
#      allowOther = true;
#      directories = [
#        #        ".config/sops"
#        #        ".zplug"
#        #        ".local/share/xorg"
#        #        ".ssh"
#        #        ".gnupg"
#      ];
#      #      files = [
#      #        ".local/share/history"
#      #      ];
#    };
#  };

}
