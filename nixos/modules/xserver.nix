{ config, pkgs, lib, ... }: {

  programs = {
     dconf.enable = true;
     light.enable = true;
   };
 
  /* ---Xserver--- */
  services.xserver = {
    enable = true;
    xkb.layout = "us";
      # Enable sx, a lightweight startx alternative
    displayManager.sx.enable = true;
      # Disable xterm
    desktopManager.xterm.enable = false;
  };

  /* ---Libinput--- */
  services.libinput = {
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


  /* ---TTY Login Prompt--- */
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
