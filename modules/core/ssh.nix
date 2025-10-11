{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.meta) username;
in {
  # Enable OpenSSH
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    allowSFTP = true;
    ports = [704];
    authorizedKeysInHomedir = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      X11Forwarding = false;
    };
    extraConfig = ''
      UsePam no
      AllowTcpForwarding yes
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
    '';
  };

  # Add SSH key
  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPxsgVkgA8fBxOOsL8WmqGa1hAzYgl7YNz/OvLiDq5fO binette@suzaku"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWNbKHKSSjQAEGlWVhrPQ8vcolszTiwNKXB0FMEBtfw binette@seiryu"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3Fo8FZrrTYGqIH84r67dkmSIxcOD3DhJrIJe6ndJ0z binette@kei"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGG8dyKr7nc8NU5WelH7qZMqZ/nzVjSMNAmlQcunSmiP binette@byakko"
  ];
}
