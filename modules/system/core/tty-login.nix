{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.services.tty-login-prompt;

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
  options.modules.services.tty-login-prompt = {
    enable = mkOption {
      description = "Customize tty login prompt";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf (cfg.enable) {
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
  };

}
