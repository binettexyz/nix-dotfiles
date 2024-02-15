{ config, pkgs, lib, ... }:

{
    # Configure the virtual console keymap from the xserver keyboard settings
    #FIXME: make font huge
  #console.useXkbConfig = true;

    # Configure special programs (i.e. hardware access)
  programs = {
    dconf.enable = true;
    light.enable = true;
  };

  services.xserver = {
    enable = true;
    xkb.layout = "us";

      # Enable sx, a lightweight startx alternative
    displayManager.sx.enable = true;
      # Enable startx
#    displayManager.startx.enable = true;
      # Disable xterm
    desktopManager.xterm.enable = false;

      # Enable libinput
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = true;
        disableWhileTyping = true;
        middleEmulation = true;
      };
      mouse = {
        accelProfile = "adaptive";
        #accelSpeed = "1";
      };
    };
  };

    # tty login prompt
  console.earlySetup = true;
  services.getty = {
    helpLine = lib.mkForce "";
    greetingLine =
      let
        c1 = "\\e[1;36m";
        c2 = "\\e[1;33m";
        nixos = [    " ${c1}          ::::.    ${c2}':::::     ::::'          "
          " ${c1}          ':::::    ${c2}':::::.  ::::'           "
          " ${c1}            :::::     ${c2}'::::.:::::            "
          " ${c1}      .......:::::..... ${c2}::::::::             "
          " ${c1}     ::::::::::::::::::. ${c2}::::::    ${c1}::::.     "
          " ${c1}    ::::::::::::::::::::: ${c2}:::::.  ${c1}.::::'     "
          " ${c2}           .....           ::::' ${c1}:::::'      "
          " ${c2}          :::::            '::' ${c1}:::::'       "
          " ${c2} ........:::::               ' ${c1}:::::::::::.  "
          " ${c2}:::::::::::::                 ${c1}:::::::::::::  "
          " ${c2} ::::::::::: ${c1}..              ${c1}:::::           "
          " ${c2}     .::::: ${c1}.:::            ${c1}:::::            "
          " ${c2}    .:::::  ${c1}:::::          ${c1}'''''    ${c2}.....    "
          " ${c2}    :::::   ${c1}':::::.  ${c2}......:::::::::::::'    "
          " ${c2}     :::     ${c1}::::::. ${c2}':::::::::::::::::'     "
          " ${c1}            .:::::::: ${c2}'::::::::::            "
          " ${c1}           .::::''::::.     ${c2}'::::.           "
          " ${c1}          .::::'   ::::.     ${c2}'::::.          "
          " ${c1}         .::::      ::::      ${c2}'::::.         "
        ];
      in
        "\n" +
        lib.concatStringsSep "\n" nixos +
        "\n\n" +
        ''\e[1;37m>>> NixOS ${config.system.nixos.label} (Linux \r) - \l\e[0m'';
    };
}
