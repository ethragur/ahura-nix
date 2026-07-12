{ self
, inputs
, ...
}:
{
  flake.nixosModules.mullvad =
    { pkgs, ... }:
    {
      services.mullvad-vpn.enable = true;
    };
}
