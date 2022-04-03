{ pkgs, ... }: {

  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    passwordAuthentication = false;
    allowSFTP = false; # Don't set this if you need sftp
    challengeResponseAuthentication = false;
    forwardX11 = false;
    publicKey = null;
    extraConfig = ''
      AllowTcpForwarding yes
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
    '';
  };

  config.users.users.binette.openssh.authorizedKeys.keys = [
      # laptop
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1QoSqbeRihMjTOlRnVIOia/K0FgZvXZlOOJdXDVE54yZ0WxEajYM3n7JgVU+JlvOjUIuzbqLla66YhIG9K2Pixaq4T6PON88aN1E5q2yuJvbu8dNpKrUQY3ZwKbdEzritsJO5YgiC0FqjnllB5SWlu2ZmadXStUV2M2btzqO4v1ZVwEVgJ/cDQe8O7UZWV/jHrPodOWQiTedrFuZPOqmqAcYLV/JEzm6oyxTmhzD6JKsHqjcxM9SAVbqb3TR7/xFzTglnQQ+ueaxcIHnmvSQdR+ii2uFtiNDbtZgQeYk3kZy2gexGrA7MbYb36X/utYKoIlm52GSj1PGGJAN+i0O5jVHIZVi+H4QBVEpaHJ0JucEMq2t3TQb0Uvc9rVxuw8dGxb5rcHmSo4w7hdN1Iwj+KdVv1YaCFoIRUTApTv+3e2fzuTYXzqTxVKNacKGTXEuTHJ1gMJnOUQqTmeDw3SCUVWlHmyZWQTlIq63Ih50ZPw/e3YnpyYu5feE1m7Y4b0= binette@bin-laptop"
  ];

}
