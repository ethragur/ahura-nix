{ inputs
, ...
}:
{
  # default settings needed for all nixosConfigurations

  flake.nixosModules.system-desktop =
    { pkgs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        system-basic
        theme
        browser
        dm
        wayland
        sway
        niri
      ];
      home-manager.sharedModules = [
        inputs.self.homeModules.system-desktop
      ];

      services.flatpak.enable = true;


      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };


      xdg = {
        portal = {
          wlr = {
            enable = true;
            settings = {
              screencast = {
                max_fps = 30;
              };
            };
          };
          enable = true;
          xdgOpenUsePortal = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-wlr
            xdg-desktop-portal-gtk
          ];
          config = {
            common = {
              default = [
                "gtk"
              ];
            };
          };
        };
      };


    };

  flake.homeModules.system-desktop =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      imports = with inputs.self.homeModules; [
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
        system-basic
      ];
    };
}
