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
                chooser_type = "simple";
                chooser_cmd = "${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -or";
              };
            };
          };
          enable = true;
          xdgOpenUsePortal = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-wlr
            xdg-desktop-portal-gtk
          ];

          config.common = {
            default = [ "gtk" ];

            "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          };
          config.sway = {
            default = [ "gtk" ];

            "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          };

        };
      };

      systemd.user.settings.Manager.ManagerEnvironment =
        "NIX_XDG_DESKTOP_PORTAL_DIR=/run/current-system/sw/share/xdg-desktop-portal/portals";


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
