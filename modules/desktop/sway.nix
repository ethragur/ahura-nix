{ self
, inputs
, ...
}: {
  flake.nixosModules.sway =
    { lib
    , ...
    }: {
      programs.sway = {
        enable = true;
        extraPackages = [ ]; # only what you actually want
      };

      home-manager.sharedModules = [
        inputs.self.homeModules.sway
      ];

    };

  flake.homeModules.sway =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      wayland.windowManager.sway = {
        enable = true;
        extraSessionCommands = ''
          export XDG_SESSION_TYPE=wayland
          export SDL_VIDEODRIVER=wayland
          export _JAVA_AWT_WM_NONREPARENTING=1
          export QT_QPA_PLATFORM=wayland
          export XDG_CURRENT_DESKTOP=sway
          export NIXOS_OZONE_WL=1
          export MOZ_ENABLE_WAYLAND=1
        '';

        config = {
          modifier = "Mod4";
          terminal = "alacritty";
          window = {
            titlebar = false;
          };
          bars = [ ];
          startup = [
            { command = "${pkgs.workstyle}/bin/workstyle"; always = true; }
            { command = "${inputs.ashell-sway.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/ashell"; always = true; }
          ];
          input = {
            "type:keyboard" = {
              xkb_layout = "us";
              xkb_variant = "altgr-intl";
              xkb_options = "caps:escape";
            };
            "type:mouse" = {
              scroll_factor = "3.0";
              pointer_accel = "0.0";
            };
            "type:touchpad" = {
              tap = "enabled";
              tap_button_map = "lmr";
              natural_scroll = "disabled";
              dwt = "enabled";
              accel_profile = "flat";
            };
          };
          keybindings =
            let
              modifier = config.wayland.windowManager.sway.config.modifier;
            in
            lib.mkOptionDefault {
              "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
              "${modifier}+c" = "exec zen-beta";
              "${modifier}+Shift+q" = "kill";
              "${modifier}+d" = "exec wofi --show drun";
              "${modifier}+0" = "workspace number 0";
              "${modifier}+Shift+0" = "move container to workspace number 0";
            };

        };
      };

    };
}


