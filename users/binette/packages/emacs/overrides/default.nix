{ pkgs }:
self: super: {
  evil = self.melpaPackages.evil;
  use-package = self.melpaStablePackages.use-package;
}
