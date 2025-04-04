{ pkgs, ... }:
{

  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox_material_dark";
      editor = {
        line-number = "relative";
        continue-comments = false;
        cursorline = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        color-modes = true;
        true-color = true;
        indent-guides = {
          render = true;
          character = "┆";
          skip-levels = 1;
        };
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };
        end-of-line-diagnostics = "hint";
        inline-diagnostics.cursor-line = "warning";
        statusline = {
          left = [
            "mode"
            "file-name"
            "spinner"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          right = [
            "diagnostics"
            "selections"
            "register"
            "file-type"
            "file-line-ending"
            "position"
          ];
          mode.normal = "N";
          mode.insert = "I";
          mode.select = "V";
        };
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        language-servers = [ "nil" ];
      }
    ];
    themes = {
      gruvbox_material_dark = {
        inherits = "gruvbox_dark_hard";
        "ui.background" = { };
        "ui.cursor.match" = {
          bg = "bg3";
        };
        palette = {
          bg0 = "#141617";
          bg1 = "#282828";
          bg2 = "#282828";
          bg3 = "#3c3836";
          bg4 = "#3c3836";
          bg5 = "#504945";
          bg_statusline1 = "#282828";
          bg_statusline2 = "#32302f";
          bg_statusline3 = "#504945";
          bg_diff_green = "#32361a";
          bg_visual_green = "#333e34";
          bg_diff_red = "#3c1f1e";
          bg_visual_red = "#442e2d";
          bg_diff_blue = "#0d3138";
          bg_visual_blue = "#2e3b3b";
          bg_visual_yellow = "#473c29";
          bg_current_word = "#32302f";

          fg0 = "#d4be98";
          fg1 = "#ddc7a1";

          red0 = "#ea6962";
          red1 = "#ea6962";
          green0 = "#a9b665";
          green1 = "#a9b665";
          yellow0 = "#d8a657";
          yellow1 = "#d8a657";
          blue0 = "#7daea3";
          blue1 = "#7daea3";
          aqua0 = "#89b482";
          aqua1 = "#89b482";
          orange0 = "#e78a4e";
          orange1 = "#e78a4e";
          purple0 = "#d3869b";
          purple1 = "#d3869b";

          grey0 = "#7c6f64";
          grey1 = "#928374";
          grey2 = "#a89984";
        };
      };
    };
    extraPackages = with pkgs; [
      nil
      nixfmt-rfc-style
    ];
  };
}
