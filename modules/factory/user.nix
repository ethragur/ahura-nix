{ self
, ...
}:
{
  config.flake.factory.user = username: isAdmin: {

    nixosModules."${username}" =
      { lib
      , pkgs
      , ...
      }:
      {
        users.users."${username}" = {
          isNormalUser = true;
          home = "/home/${username}";
          extraGroups = lib.optionals isAdmin [
            "wheel"
          ];
          shell = pkgs.fish;
        };
        programs.fish.enable = true;

        home-manager.users."${username}" = {
          imports = [
            self.homeModules."${username}"
          ];
        };
      };

    homeModules."${username}" = {
      home.username = "${username}";
    };
  };
}
