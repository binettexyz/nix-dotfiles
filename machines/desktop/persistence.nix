{ config, ... }:
let
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in {

     programs.fuse.userAllowOther = true;

     home-manager.users.binette = {
       imports = [ "${impermanence}/home-manager.nix" ];
         # dotfiles
       home.persistence = {
         "/nix/persist/home/binette" = {
           removePrefixDirectory = false;
           allowOther = true;

           directories = [
             ".cache/flatpak"

             ".local/share/airshipper"
             ".local/share/flatpak"
             ".local/share/multimc"
             ".local/share/Steam"

             ".steam"

             ".var"
           ];

#           files = [
#           ];
         };
       };
     };
}
