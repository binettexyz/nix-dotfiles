{ config, pkgs, ... }: {

  imports =
    [
      ./packages
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
      extraGroups = [ "wheel" "binette" "users" "audio" "video" ];
      hashedPassword = "$6$sXbE2tHuk9pd63mA$B10NqVR9zqwvod5acnGhK0sYPZ3JiV592PYG.DMswbFEgflfR.QOticvEGFMkLvsENsBUWefDOfR26RUxlRHS0";
      openssh.authorizedKeys.keys = [
        # laptop
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1QoSqbeRihMjTOlRnVIOia/K0FgZvXZlOOJdXDVE54yZ0WxEajYM3n7JgVU+JlvOjUIuzbqLla66YhIG9K2Pixaq4T6PON88aN1E5q2yuJvbu8dNpKrUQY3ZwKbdEzritsJO5YgiC0FqjnllB5SWlu2ZmadXStUV2M2btzqO4v1ZVwEVgJ/cDQe8O7UZWV/jHrPodOWQiTedrFuZPOqmqAcYLV/JEzm6oyxTmhzD6JKsHqjcxM9SAVbqb3TR7/xFzTglnQQ+ueaxcIHnmvSQdR+ii2uFtiNDbtZgQeYk3kZy2gexGrA7MbYb36X/utYKoIlm52GSj1PGGJAN+i0O5jVHIZVi+H4QBVEpaHJ0JucEMq2t3TQb0Uvc9rVxuw8dGxb5rcHmSo4w7hdN1Iwj+KdVv1YaCFoIRUTApTv+3e2fzuTYXzqTxVKNacKGTXEuTHJ1gMJnOUQqTmeDw3SCUVWlHmyZWQTlIq63Ih50ZPw/e3YnpyYu5feE1m7Y4b0= binette@bin-laptop"
      ];
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
