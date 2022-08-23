{

  imports = [
    ../../modules/xprofile/laptop.nix
  ];

  environment.systemPackages = with pkgs; [ zoom-us ];
}
