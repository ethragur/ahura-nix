{ self
, inputs
, ...
}: {
  flake.nixosModules.wayland =
    { lib
    , ...
    }: {
      imports = with self.nixosModules; [
      ];

      home-manager.sharedModules = [
        inputs.self.homeModules.wayland
      ];

    };

  flake.homeModules.wayland =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      stylix.targets.gtk.flatpakSupport.enable = false;
      programs.wofi = {
        enable = true;
        settings = {
          width = "1280";
          height = "720";
          prompt = "";
          allow_images = true;
          allow_markup = true;
          term = "alacritty";
          hide_scroll = true;
          insensitive = true;
          image_size = 24;
        };
      };

      stylix.targets.swaylock.enable = true;
      stylix.targets.swaylock.image.enable = true;

      programs.swaylock = {
        enable = true;
        settings = {
          ignore-empty-password = true;
          daemonize = true;
          show-failed-attempts = true;
          scaling = "fill";
          indicator-idle-visible = true;
          indicator-radius = 256;
          indicator-thickness = 256;
          indicator-caps-lock = true;
        };
      };


      services.kanshi = {
        enable = true;
      };


      stylix.targets.mako.enable = true;
      services.mako = { enable = true; };

      stylix.targets.ashell.enable = true;

      programs.ashell = {
        enable = true;
        package = inputs.ashell-sway.packages.${pkgs.stdenv.hostPlatform.system}.default;
        settings = {
          log_level = "warn";
          position = "Top";
          language = "en-US";
          region = "at-AT";

          modules = {
            left = [ "appLauncher" "Tempo" "SystemInfo" ];
            center = [ "Workspaces" ];
            right = [ "MediaPlayer" "Settings" [ "Tray" ] ];
          };

          workspaces = {
            visibility_mode = "MonitorSpecificExclusive";
            enable_workspace_filling = false;
          };

          CustomModule = [
            {
              name = "appLauncher";
              icon = "󱗼";
              command = "${pkgs.wofi}/bin/wofi --show drun";
            }
          ];
          window_title = {
            mode = "Title";
            truncate_title_after_length = 100;
          };
          system_info = {
            indicators = [ "Cpu" "Memory" "Temperature" ];
            interval = 5;
            cpu = {
              warn_threshold = 60;
              alert_threshold = 80;
            };
            memory = {
              warn_threshold = 70;
              alert_threshold = 85;
            };
            temperature = {
              warn_threshold = 60;
              alert_threshold = 80;
              sensor = "acpitz temp1";
            };
          };
          tempo = {
            clock_format = "%a %d %b %R";
            weather_location = {
              City = "Innsbruck";
            };
            weather_indicator = "IconAndTemperature";
          };
          appearance = {
            font_name = "${config.stylix.fonts.monospace.name}";
            style = "Solid";
            scale_factor = 1.2;
          };
        };
      };
    };
}


