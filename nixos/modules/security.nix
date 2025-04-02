{ pkgs, ... }: {

  security = {
      # prevent replacing the running kernel image
    protectKernelImage = true;
    sudo.enable = false;
    doas = {
      enable = true;
      wheelNeedsPassword = false;
      extraRules = [{ users = [ "binette" ]; noPass = true; keepEnv = true; }];
    };
    acme.acceptTerms = true;
    acme.defaults.email = "binettexyz@proton.me";
  };

  environment.systemPackages = with pkgs; [ doas-sudo-shim ];

   boot.blacklistedKernelModules = [
      # Obscure network protocols
    "ax25" "netrom" "rose"
      # Obscure/Legacy Filesystems
    "adfs" "affs" "bfs" "befs" "efs" "erofs"
    "exofs" "freevxfs" "f2fs" "vivid" "gfs2"
    "cramfs" "jffs2" "hfs" "hfsplus" "hpfs"
    "jfs" "minix" "nilfs2" "omfs" "qnx4"
    "qnx6" "sysv" "ufs"
    "ksmbd" # SMB server module
    "cifs" # Windows share
    "uvcvideo" # Webcam
  ];

}
