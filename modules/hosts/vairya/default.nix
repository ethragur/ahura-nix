{ self
, inputs
, ...
}: {
  flake.nixosConfigurations.vairya = inputs.nixpkgs.lib.nixosSystem {

    modules = with self.nixosModules; [
      vairyaConfiguration
    ];

  };
}
