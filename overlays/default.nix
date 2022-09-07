{ pkgs, lib, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
#      dwm = prev.dwm.overrideAttrs (old: {
#        src = builtins.fetchTarball {
#          url = "https://github.com/binettexyz/dwm/tree/47233703d3f5ed777d754b07148cc2f9d105517b.tar.gz";
#          sha256 = "";
#        };
#      });
#      dmenu = prev.dmenu.overrideAttrs (old: {
#        src = builtins.fetchTarball {
#          url = "https://github.com/binettexyz/dmenu/archive/master.tar.gz";
#          sha256 = "sha256:0rs5ny8n3rn0qppan5nbyfx2pwpsc0i9pakbkbva1v97bnqbn6b6";
#        };
#      });
#      slstatus = prev.slstatus.overrideAttrs (old: {
#        src = builtins.fetchTarball {
#          url = "https://github.com/binettexyz/slstatus/archive/master.tar.gz";
#          sha256 = "sha256:108h9xd8sn4s6hngw965kw2jjh8hjcnb1g6d8waimpdyiz4kry70";
#        };
#      });
      st = prev.st.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ prev.harfbuzz ];
        src = builtins.fetchTarball {
          url = "https://github.com/LukeSmithxyz/st/archive/master.tar.gz";
          sha256 = "sha256:1lsx32v085g50rg933is3ww20yysri4mh96sz3mw372iqxzwscrz";
        };
      });
      Anime4k = prev.callPackage ../modules/pkgs/anime4k { };
    })
  ];
}
