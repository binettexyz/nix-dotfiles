{ config, pkgs, ... }: {

        imports = [
                ./persistence.nix
                ./../shared
#                <impermanence/home-manager.nix>
        ];

        users.groups.binette.gid = 1000;
        users.users.binette = {
                uid = 1000;
                isNormalUser = true;
                createHome = true;
                home = "/home/binette";
                group = "binette";
                extraGroups = [ "wheel" "binette" "users" "audio" "video" "storage" "libvirtd" ];
                hashedPassword = "$6$89SIC2h2WeoZT651$26x4NJ1vmX9N/B54y7mc5pi2INtNO0GqQz75S37AMzDGoh/29d8gkdM1aw6i44p8zWvLQqhI0fohB3EWjL5pC/";
        };

          # unlock gpg keys with my login password (not working)
#        security.pam.services.login.gnupg.enable = true;
#        security.pam.services.login.gnupg.noAutostart = true;
#        security.pam.services.login.gnupg.storeOnly = true;

          # remove passwd prompt
        security.doas.extraRules = [{
                users = [ "binette" ]; noPass = true; keepEnv = true; }
        ];

          # packages & programs
        home-manager.users.binette.home = {
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
#                        mcrcon
                ];
        };
}
