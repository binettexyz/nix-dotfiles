{ pkgs, ... }: {

    # install packages
  environment.systemPackages = with pkgs; [
      # irc
#    weechat
      # others
    unstable.ripcord
    unstable.zoom-us
#    unstable.teams
#    unstable.discord
  ];

}
