{ config, pkgs, ... }: {



    services.transmission = {
      enable = true;
      user = "transmission";
      group = "transmission";
      openFirewall = true;
      settings = {
        download-dir = /nix/persist/media/downloads/torrents;
        blocklist-enabled = true;
        blocklist-url = "http://list.iblocklist.com/?list=ydxerpxkpcfqjaybcssw&fileformat=p2p&archiveformat=gz";
        encryption = 1;
        incomplete-dir = /nix/persist/media/downloads/torrents/.incomplete;
        incomplete-dir-enabled = true;
        message-level = 1;
        peer-port = 50778;
        peer-port-random-high = 65535;
        peer-port-random-low = 49152;
        peer-port-random-on-start = true;
#        rpc-bind-address = "100.71.254.90";
        rpc-bind-address = "0.0.0.0";
        rpc-port = 9091;
        rpc-enable = true;
        rpc-authentication-required = true;
        rpc-username = "binette";
        rpc-password = "cd";
        script-torrent-done-enabled = true;
        script-torrent-done-filename = /home/binette/.local/bin/tordone;
        umask = 18;
        utp-enabled = true;
        rpc-whitelist-enabled = false;
      };
    };

}

