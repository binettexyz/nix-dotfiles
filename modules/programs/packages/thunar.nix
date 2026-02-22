{
  flake.nixosModules.thunar = {
    programs.thunar.enable = true;

    # Mount, trash and other fonctionalities
    services.gvfs.enable = true;
    # Thumbnail support for images
    services.tumbler.enable = true;
  };
}
