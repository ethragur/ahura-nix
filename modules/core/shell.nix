{ self
, inputs
, ...
}:
{
  flake.nixosModules.shell =
    { pkgs, ... }:
    {
      home-manager.sharedModules = [
        inputs.self.homeModules.shell
      ];
    };

  flake.homeModules.shell =
    { pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        shellAliases = {
          ll = "ls -l";
          dd = "dd status=progress";
          mkdir = "mkdir -pv";
          cx = "chmod +x";
          update = "nh os switch";
          sudo = "doas";
        };
        functions = {
          last_history_item = "echo \$history[1]";
        };
        interactiveShellInit = ''
          set fish_greeting ""
          abbr -a !! --position anywhere --function last_history_item
        '';
      };
      programs.starship.enable = true;
    };
}
