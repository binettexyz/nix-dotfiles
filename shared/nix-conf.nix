{
  sandbox = true;
  auto-optimise-store = true;
  trusted-users = [ "root" "@wheel" ];
  experimental-features = [ "nix-command" "flakes" ];
  # Useful for nix-direnv, however not sure if this will
  # generate too much garbage
  #extraOptions = ''
  #  keep-outputs = true;
  #  keep-derivations = true;
  #'';
}
