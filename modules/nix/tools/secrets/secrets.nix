{ inputs, ... }:
{
  flake.nixosModules.secrets =
    { config, pkgs, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      environment.systemPackages = [ pkgs.sops ];

      sops = {
        defaultSopsFile = ./secrets.yaml;
        age = {
          # This will automatically import SSH keys as age keys
          sshKeyPaths = [ "/home/${config.meta.username}/.ssh/id_ed25519" ];
          keyFile = "/home/${config.meta.username}/sops/key.txt";
          # This will generate a new key if the key specified above does not exist
          generateKey = true;
        };
      };
    };

  flake.modules.homeManager.secrets = {
    imports = [ inputs.sops-nix.homeManagerModules.sops ];
  };
}
