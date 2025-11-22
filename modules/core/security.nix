{
  lib,
  pkgs,
  ...
}:
let
  baseUrl = "https://raw.githubusercontent.com/StevenBlack/hosts";
  commit = "37cd96c0fe95ad3357b9dffe9e612f7e539ece35";
  hostsFile = pkgs.fetchurl {
    url = "${baseUrl}/${commit}/alternates/fakenews-gambling/hosts";
    sha256 = "sha256-sMIrZtUaflOGFtSL3Nr9jSfnGPA/goE0RAZ8jlNVvAs=";
  };
  hostsContent = lib.readFile hostsFile;
in
{
  security = {
    # prevent replacing the running kernel image
    protectKernelImage = true;
    sudo.enable = false;
    doas = {
      enable = true;
      wheelNeedsPassword = false;
      extraRules = [
        {
          users = [ "binette" ];
          noPass = true;
          keepEnv = true;
        }
      ];
    };
  };

  # Add StevenBlack hosts.
  networking.extraHosts = hostsContent;

  environment.systemPackages = [ pkgs.doas-sudo-shim ];

  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"
    # Obscure/Legacy Filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "vivid"
    "gfs2"
    "cramfs"
    "jffs2"
    "hfs"
    "hfsplus"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
    "ksmbd" # SMB server module
    "cifs" # Windows share
    "uvcvideo" # Webcam
  ];
}
