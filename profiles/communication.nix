{ pkgs, ... }: {

    # install packages
  environment.systemPackages = with pkgs; [
      # matrix
    weechatScripts.weechat-matrix
      # irc
    weechat
      # others
    ripcord
    zoom-us
  ];

}
