{ config, pkgs, lib, ... }:

let

  c1 = "\\e[22;31m";
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

{

    # enable X server
  services.xserver = {
    enable = true;
    layout = "us";
      # disable xterm
    desktopManager.xterm.enable = false;
  };


    # enable startx as display manager
  services.xserver.displayManager.startx.enable = lib.mkDefault true;

    # tty login prompt
  console.earlySetup = true;
  services.getty = {
    helpLine = lib.mkForce "";
    greetingLine =
      "\n" +
      lib.concatStringsSep "\n" nixos +
      "\n\n" +
      ''\e[1;37m>>> NixOS ${config.system.nixos.label} (Linux \r) - \l\e[0m'';
    };

}
