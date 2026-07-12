{ self
, inputs
, ...
}:
{
  # This is an example dendritic nixos module, and also a template for new modules
  flake.nixosModules.example =
    { pkgs, ... }:
    {

      imports = with self.nixosModules; [
        # Here you can import other dendritic modules by just putting the module name here
        # myModule
        # Or use external flake modules
        # inputs.externalModule.nixosModules.externalModule
      ];


      # This auto imports the home-manager stuff as well, and is nearly always required
      home-manager.sharedModules = [
        inputs.self.homeModules.example
      ];

      # Here you can define any other nixos options
      packages.hello = {
        enable = true;
      };

      # ...

    };

  # the home-manager part of the module
  flake.homeModules.example =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      # In this section any home-manager options are defined
      home.packages = [
        # Home packages are defined here
        # Also nixpak sandboxed apps can be used here, see declaration of nixpak packages down there
        # self.packages.${pkgs.stdenv.hostPlatform.system}.examplePackage
      ];
      programs.example = {
        enable = true;
	# if nixpak needs to change a program, use the package override
	# package = self.packages.${pkgs.stdenv.hostPlatform.system}.examplePackage;

        settings = { };
      };
    };


  # Define sandboxed versions of package
  perSystem = { pkgs, lib, ... }:
    # The default generator for nixpak packages
    let
      mkNixPak = inputs.nixpak.lib.nixpak {
        inherit (pkgs) lib;
        inherit pkgs;
      };

      wrap = package: config: (mkNixPak {
        config = { sloth, ... }:
          lib.recursiveUpdate
            {
              app.package = package;
              bubblewrap.network = false;
            }
            (config sloth);
      }).config.script;
    in
    {
      packages = {
        # Define the name and which package it inherits from
        examplePackage = wrap pkgs.example (sloth: {
          # nixpak sandbox settings:
          dbus.enable = true;
          bubblewrap.network = true;
          bubblewrap.bind.rw = [
            (sloth.concat' sloth.homeDir "/Downloads")
          ];
        });
      };
    };
}

