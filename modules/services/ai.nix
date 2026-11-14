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
    };

  flake.homeModules.ai =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      imports = [ inputs.pi.homeModules.default ];
      home.packages = with pkgs; [
        llama-cpp-vulkan
      ];

      programs.pi.coding-agent = {
        enable = true;
        # rules = ''Be concise.'';
        # skills = [ ./skills/my-skill ];
        # models = ./models.json;
        # settings.model = "gpt-5";
        environment.PI_CODING_AGENT_DIR.value = "${config.home.homeDirectory}/.config/pi/agent";
        jail = {
          enable = true;
        };
      };
    };
}
