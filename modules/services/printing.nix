{ self
, inputs
, ...
}:
{
  flake.nixosModules.printing =
    { pkgs, ... }:
    { };
}
