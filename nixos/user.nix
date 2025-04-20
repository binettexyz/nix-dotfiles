{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.meta) username;
in
{
  users = {
    # FIXME: if set to pkgs.zsh, error saying that programs.zsh.enable is not true, which is not true...
    defaultUserShell = lib.mkForce "/etc/profiles/per-user/${username}/bin/zsh";
    mutableUsers = false;
    groups.${username}.gid = 1000;
    users.${username} = {
      uid = 1000;
      isNormalUser = true;
      createHome = true;
      home = "/home/${username}";
      group = "${username}";
      extraGroups = [
        "wheel"
        "${username}"
        "users"
        "audio"
        "video" # "docker"
      ];
      hashedPassword = "$6$89SIC2h2WeoZT651$26x4NJ1vmX9N/B54y7mc5pi2INtNO0GqQz75S37AMzDGoh/29d8gkdM1aw6i44p8zWvLQqhI0fohB3EWjL5pC/";
    };
    users.root = {
      hashedPassword = "$6$rxT./glTrsUdqrsW$Wzji63op8yTEBoIEcWBc26KOlFJtqx.EKpsGV1A2bQT9oB1JKtrlfdArYICc/Ape.msHcj6ObyXlmRKTWTC/J.";
    };
  };

}
