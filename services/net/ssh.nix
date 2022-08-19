{ config, pkgs, ... }: {

  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    passwordAuthentication = true;
#    allowSFTP = false; # Don't set this if you need sftp
    kbdInteractiveAuthentication = false;
    forwardX11 = false;
    extraConfig = ''
      AllowTcpForwarding yes
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
    '';
      #AuthenticationMethods publickey
  };

}
