{ pkgs, lib, nixpkgs, nixpkgs-unstable, system, ... }: {

  nixpkgs.overlays =
  let

    overlay-unstable = self: super: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        config.allowBroken = true;
      };
    };

  in [

    overlay-unstable
    (final: prev: {
      st = prev.st.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ prev.harfbuzz ];
        src = builtins.fetchTarball {
          url = "https://github.com/LukeSmithxyz/st/archive/master.tar.gz";
          sha256 = "sha256:1lsx32v085g50rg933is3ww20yysri4mh96sz3mw372iqxzwscrz";
        };
      });
      anime4k = prev.callPackage ../modules/pkgs/anime4k { };
#      dwm-head = prev.callPackage /home/binette/.git/repos/dwm {};
    })

  ];
}
