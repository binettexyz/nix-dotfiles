{ pkgs, ... }: {

    # install packages
  environment.systemPackages = with pkgs; [
      # matrix
    weechatScripts.weechat-matrix
      # irc
    weechat
      # others
    unstable.ripcord
    unstable.zoom-us
    unstable.teams
  ];

}
