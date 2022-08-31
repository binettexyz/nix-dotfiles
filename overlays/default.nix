{ pkgs, lib, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (old: {
        src = pkgs.fetchFromGitHub {
          owner = "binettexyz";
          repo = "dwm";
          rev = "5a22d28e48a6cf44989982e28d76d367d54fe492";
          sha256 = "sha256-2U01hJpKEpy5/4JWiQu9PiG20L8EFcT2rx6lRAPlNFg=";
        };
      });
      dmenu = prev.dmenu.overrideAttrs (old: {
        src = pkgs.fetchFromGitHub {
          owner = "binettexyz";
          repo = "dmenu";
          rev = "8adc9f4d48956767a685c24a2927942f307403cd";
          sha256 = "sha256-I8HLOxafOpsc5ZOYunte8Wt14Lx58ruizL2fmgb42mU=";
        };
      });
      slstatus = prev.slstatus.overrideAttrs (old: {
        src = pkgs.fetchFromGitHub {
          owner = "binettexyz";
          repo = "slstatus";
          rev = "4f00e50beb99c6d30393f89f27eba19a580ae222";
          sha256 = "sha256-wxnB9YsMDDuXrz/fzGa7ulF5/4CoPNna5pe7izMuea4=";
        };
      });
      st = prev.st.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ prev.harfbuzz ];
        src = pkgs.fetchFromGitHub {
          owner = "lukesmithxyz";
          repo = "st";
          rev = "13b3c631be13849cd80bef76ada7ead93ad48dc6";
          sha256 = "009za6dv8cr2brs31sjqixnkk3jwm8k62qk38sz4ggby3ps9dzf4";
        };
      });
    })
  ];
}
