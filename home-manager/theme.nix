{ pkgs, ... }:
{

  # Gtk
  gtk = {
    enable = true;

    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };

    theme = {
      package = pkgs.gruvbox-material-gtk;
      name = "Gruvbox-Material-Dark";
    };

    iconTheme = {
      package = pkgs.gruvbox-material-gtk;
      name = "Gruvbox-Material-Dark";
    };

    cursorTheme = {
      package = pkgs.capitaine-cursors-themed;
      name = "Capitaine Cursors (Gruvbox)";
      size = 24;
    };

    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

  };

  home.sessionVariables = {
    GTK_THEME = "Gruvbox-Material-Dark";
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  # Qt
  #  qt = {
  #    enable = true;
  #    platformTheme.name = "gtk";
  #  };

}
