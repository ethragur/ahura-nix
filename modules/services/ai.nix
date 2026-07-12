{ self
, inputs
, ...
}:
{
  flake.nixosModules.ai =
    { pkgs, ... }:
    {
      home-manager.sharedModules = [
        inputs.self.homeModules.ai
      ];
      nix.settings = {
        extra-substituters = [ "https://cache.numtide.com" ];
        extra-trusted-public-keys = [
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        ];
      };
    };

  flake.homeModules.ai =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      home.packages =
        let
          agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

          piWrapped = pkgs.writeShellScriptBin "pi" ''
            exec ${agents.nono}/bin/nono \
              run --profile always-further/pi -- \
              ${agents.pi}/bin/pi "$@"
          '';
        in
        [
          piWrapped
        ];
    };
}
