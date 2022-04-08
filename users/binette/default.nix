{ config, pkgs, ... }: {

  imports =
    [
      ./persistence.nix
    ];

  users = {
    groups.binette.gid = 1000;
    users.binette = {
      uid = 1000;
      isNormalUser = true;
      createHome = true;
      home = "/home/binette";
      group = "binette";
      extraGroups = [ "wheel" "binette" "users" "audio" "video" "syncthing" ];
      hashedPassword = "$6$sXbE2tHuk9pd63mA$B10NqVR9zqwvod5acnGhK0sYPZ3JiV592PYG.DMswbFEgflfR.QOticvEGFMkLvsENsBUWefDOfR26RUxlRHS0";
    };
  };

#  home = {
#    sessionPath = [ "$HOME/.local/bin/*" ];
#    sessionVariables = {
#      EDITOR = "nvim";
#      BROWSER = "firefox";
#    };


    # packages & programs
  home-manager.users.binette.home = {
    file.".config/startkderc".text = ''
      [General]
      systemdBoot=false
    '';
    homeDirectory = "/home/binette";
    packages = with pkgs; [
        # kindle
      calibre
      calibre-web
        # emails
      mutt-wizard
      neomutt
      isync
      msmtp
      lynx
      notmuch
      abook
      urlview
      mpop
        #rcon
      mcrcon
    ];
  };
}
