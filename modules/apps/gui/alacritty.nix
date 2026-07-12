{ self
, inputs
, ...
}: {
  flake.nixosModules.terminal =
    { lib
    , ...
    }: {
      home-manager.sharedModules = [
        inputs.self.homeModules.terminal
      ];
    };

  flake.homeModules.terminal =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      stylix.targets.alacritty.enable = true;
      home.sessionVariables.TERMINAL = "alacritty";
      programs.alacritty.settings = {
        env = {
          TERM = "xterm-256color";
        };
      };
    };
}

