{
  description = "Binette's NixOS Configuration";

  /* --- System's Inputs--- */

  inputs = {
    /* --- Default Nixpkgs --- */
#    nixpkgs.follows = "master";

    /* --- Nixpkgs branches --- */
    master.url = "github:NixOS/nixpkgs/master";
    stable.url = "github:NixOS/nixpkgs/21.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    /* --- Others --- */
    flake-utils.url = "github:numtide/flake-utils";
    home.url = "github:nix-community/home-manager/master";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-gaming.url = "github:fufexan/nix-gaming";
    sops-nix.url = "github:Mic92/sops-nix";
    plasma-manager.url = "github:pjones/plasma-manager";

    /* --- Suckless Software --- */
    dwm = { url = "github:binettexyz/dwm"; flake = false; };
    st = { url = "github:binettexyz/st"; flake = false; };
    slstatus-laptop = { url = "github:binettexyz/slstatus"; flake = false; };
    slstatus-desktop = { url = "github:binettexyz/slstatus/desktop"; flake = false; };
    dmenu = { url = "github:binettexyz/dmenu"; flake = false; };

      /* --- Discord stuff --- */
#    powercord-overlay.url = "github:LavaDesu/powercord-overlay";
#    disc-betterReplies = { url = "github:cyyynthia/better-replies"; flake = false; };
#    disc-doubleClickVC = { url = "github:discord-modifications/double-click-vc"; flake = false; };
#    disc-muteNewGuild = { url = "github:RazerMoon/muteNewGuild"; flake = false; };
#    disc-popoutFix = { url = "github:Nexure/PowerCord-Popout-Fix"; flake = false; };
#    disc-screenshareCrack = { url = "github:discord-modifications/screenshare-crack"; flake = false; };
#    disc-unindent = { url = "github:VenPlugs/Unindent"; flake = false; };
#    disc-silentTyping = { url = "github:svby/powercord-silenttyping"; flake = false; };
#    disc-gruvbox = { url = "github:binettexyz/discord-gruvbox"; flake = false; };

    /* --- Minimize duplicate instances of inputs --- */
    home.inputs.nixpkgs.follows = "unstable";
    nix-gaming.inputs.nixpkgs.follows = "unstable";
    sops-nix.inputs.nixpkgs.follows = "unstable";
    plasma-manager.inputs = { nixpkgs.follows = "unstable"; home-manager.follows = "home"; };
  };

  /* ---System's Output--- */


  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, ... }@inputs:
    let
      inherit (flake-utils.lib) eachDefaultSystem;
      inherit (import ./lib/attrsets.nix { inherit (nixpkgs) lib; }) recursiveMergeAttrs;
      inherit (import ./lib/flake.nix inputs) mkNixOSConfig mkHomeConfig;
    in
    (recursiveMergeAttrs [ # Begining recursiveMergeAttrs
      # Templates
      {
        templates = {
          default = self.outputs.templates.new-host;
          new-host = {
            path = ./templates/new-host;
            description = "Create a new host";
          };
        };
      }

      # NixOS configs
      (mkNixOSConfig { hostname = "desktop"; system = "x86_64-linux"; nixosSystem = nixpkgs-unstable.lib.nixosSystem; })
      (mkNixOSConfig { hostname = "x240"; system = "x86_64-linux"; nixosSystem = nixpkgs-unstable.lib.nixosSystem; })
      (mkNixOSConfig { hostname = "t440p"; system = "x86_64-linux"; nixosSystem = nixpkgs-unstable.lib.nixosSystem; })
      (mkNixOSConfig { hostname = "server"; system = "aarch64-linux"; nixosSystem = nixpkgs-unstable.lib.nixosSystem; })

      # Home-Manager configs
      (mkHomeConfig { hostname = "home-linux"; })

      # shell.nix
      (eachDefaultSystem (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              coreutils
              findutils
              gnumake
              nixpkgs-fmt
              nixFlakes
            ];
          };
        }))
    ]); # END recursiveMergeAttrs
}

