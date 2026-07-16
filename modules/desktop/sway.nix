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
      programs.workstyle = {
        enable = true;
        settings = {
          alacritty = "";
          github = "";
          rust = "";
          google = "";
          firefox = "";
          zen = "";
          chrome = "";
          chromium = "";
          nnn = "";
          "file manager " = "";
          "libreoffice calc" = "󱎏";
          "libreoffice writer" = "";
          libreoffice = "󰏆";
          nvim = "";
          gthumb = "";
          menu = "󰍜";
          calculator = "";
          transmission = "";
          qbittorrent = "";
          videostream = "";
          mpv = "";
          music = "󰝚";
          "disk usage" = "";
          ".pdf" = "";
          steam = "󰓓";
          heroic = "󰊗";
          games = "󰊗";
          corectrl = "";
          godot = "";
          blender = "󰂫";
          wine = "󰡶";
          discord = "󰙯";
          mattermost = "󰭹";
          thunderbird = "";
          other = {
            fallback_icon = "󰘔";
            separator = ": ";
          };

        };
      };


      wayland.windowManager.sway = {
        enable = true;
        # package = pkgs.swayfx;
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
            { command = "${pkgs.workstyle}/bin/workstyle"; }
            { command = "${inputs.ashell-sway.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/ashell"; }
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
          gaps = {
            left = 4;
            right = 4;
            bottom = 2;
            top = 2;
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
              "${modifier}+Alt+l" = "exec swaylock";
              "XF86PowerOff" = "exec sh -c 'swaylock -f && systemctl suspend'";
            };
        };
        # extraConfig = ''
        #   corner_radius 4
        # '';
      };

    };
}


