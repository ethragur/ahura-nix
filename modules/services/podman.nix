{ self
, inputs
, ...
}:
{
  flake.nixosModules.podman =
    { pkgs, ... }:
    {
      home-manager.sharedModules = [
        inputs.self.homeModules.podman
      ];
      virtualisation.podman.enable = true;

    };

  flake.homeModules.podman =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      home.packages = with pkgs; [ podman podman-compose ];
    };
}

