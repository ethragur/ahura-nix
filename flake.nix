{
  description = "My NixOS configuration";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    import-tree.url = "github:vic/import-tree";

    agenix.url = "github:ryantm/agenix";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    ashell-sway = {
      url = "github:ethragur/ashell-sway";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    private-config = {
      url = "git+file:/home/effi/Documents/Development/ahura/secrets?shallow=1";
      flake = false; # or true, if it has its own outputs
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak?ref=latest";
    };

    pi = {
      url = "github:lukasl-dev/pi.nix";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; }
      (inputs.import-tree [ ./modules "${inputs.private-config}" ]);
}
