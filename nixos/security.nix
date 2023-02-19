{ ... }: {

  security = {
      # prevent replacing the running kernel image
    protectKernelImage = true;
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [{ users = [ "binette" ]; noPass = true; keepEnv = true; }];
    };
    acme.acceptTerms = true;
    acme.defaults.email = "binettexyz@proton.me";
  };

   boot.blacklistedKernelModules = [
      # Obscure network protocols
    "ax25"
    "netrom"
    "rose"
      # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "vivid"
    "gfs2"
    "ksmbd"
#    "nfsv4"
#    "nfsv3"
    "cifs"
#    "nfs"
    "cramfs"
    "freevxfs"
    "jffs2"
    "hfs"
    "hfsplus"
    "squashfs"
    "udf"
#    "bluetooth"
    "btusb"
#    "uvcvideo" # webcam
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "omfs"
    "uvcvideo"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
  ];

}
