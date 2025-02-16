{ config, lib, pkgs, ... }:
let
  inherit (config.meta) username;
in
  {
      # Enable OpenSSH
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      allowSFTP = true;
      ports = [ 704 ];
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
        Match Address 100.67.150.87
              PermitrootLogin yes
      '';
    };
  
      # Add SSH key
    users.users.${username}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPxsgVkgA8fBxOOsL8WmqGa1hAzYgl7YNz/OvLiDq5fO binette@desktop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWNbKHKSSjQAEGlWVhrPQ8vcolszTiwNKXB0FMEBtfw binette@decky"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3Fo8FZrrTYGqIH84r67dkmSIxcOD3DhJrIJe6ndJ0z binette@t440p"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKWeBglzVFzHXfNq/T+Hu31ukZ3iN6I5UXBpxIN7MRAP binette@x240"
    ];
}
