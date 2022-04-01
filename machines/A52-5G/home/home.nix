{ ... }:

{
  home = {
    file = {
      nixConf = {
	target = ".config/nix/nix.conf";
        text = ''
          keep-outputs = true
          keep-derivations = true
        '';
      };
    };
										          stateVersion = "21.11";
  };

   # Use the same overlays as the system packages
 # nixpkgs.overlays = config.nixpkgs.overlays;

}
