{ self, lib, ... }:
let
  base = self.factory.user "mithra" true;
in
{
  flake.nixosModules.mithra =
    { lib, pkgs, ... }:
    {
      imports = [ base.nixosModules.mithra ];
      users.users.mithra = {
        initialPassword = "test1234";
      };
    };

  flake.homeModules.mithra =
    { pkgs, ... }:
    {
      imports = [ base.homeModules.mithra ];
      home.packages = with pkgs; [
        mediainfo
      ];
    };
}
