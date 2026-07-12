{ self
, inputs
, ...
}: {
  flake.nixosModules.niri =
    { pkgs
    , ...
    }: {
      nixpkgs.overlays = [ inputs.niri.overlays.niri ];
      programs.niri.enable = true;
      programs.niri.package = pkgs.niri-stable;

      home-manager.sharedModules = [
        inputs.self.homeModules.niri
      ];
    };

  flake.homeModules.niri =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      imports = [ inputs.niri.homeModules.niri inputs.niri.homeModules.stylix ];

      stylix.targets.niri.enable = true;
      programs.niri = {
        enable = true;

        settings = {
          # Environment variables for niri-spawned processes
          environment = {
            XDG_SESSION_TYPE = "wayland";
            SDL_VIDEODRIVER = "wayland";
            _JAVA_AWT_WM_NONREPARENTING = "1";
            QT_QPA_PLATFORM = "wayland";
            XDG_CURRENT_DESKTOP = "niri";
            NIXOS_OZONE_WL = "1";
            MOZ_ENABLE_WAYLAND = "1";
          };

          prefer-no-csd = true;
          clipboard.disable-primary = true;


          # Input configuration
          input = {
            keyboard.xkb = {
              layout = "us";
              variant = "altgr-intl";
              options = "caps:escape";
            };
            mouse.scroll-factor = 3.0;
            mouse.accel-profile = "flat";
            mouse.accel-speed = 0.0;
            touchpad = {
              tap = true;
              tap-button-map = "left-middle-right";
              natural-scroll = false;
              dwt = true;
              accel-profile = "flat";
            };
            focus-follows-mouse.enable = true;
            focus-follows-mouse.max-scroll-amount = "0%";


          };

          window-rules = [
            {
              geometry-corner-radius = {
                top-left = 12.0;
                top-right = 12.0;
                bottom-left = 12.0;
                bottom-right = 12.0;
              };
              clip-to-geometry = true;
              default-column-width.proportion = 0.5;
            }
            {
              matches = [
                { app-id = "^zen-beta$"; }
              ];
              default-column-width = {
                proportion = 1.0;
              };
            }
          ];


          # Keybindings
          binds = {
            "Mod+Shift+Slash".action.show-hotkey-overlay = { };
            "Mod+Return".action.spawn = [ "${pkgs.alacritty}/bin/alacritty" ];
            "Mod+c".action.spawn = [ "zen-beta" ];
            "Mod+Shift+q".action.close-window = { };
            "Mod+Ctrl+Shift+q".action.quit = { };
            "Mod+d".action.spawn = [ "${pkgs.wofi}/bin/wofi" "--show" "drun" ];
            "Mod+O".action.toggle-overview = { };
            "Mod+H".action.focus-column-left = [ ];
            "Mod+L".action.focus-column-right = [ ];
            "Mod+J".action.focus-window-down = { };
            "Mod+K".action.focus-window-up = { };
            "Mod+Ctrl+H".action.move-column-left = { };
            "Mod+Ctrl+J".action.move-window-down = { };
            "Mod+Ctrl+K".action.move-window-up = { };
            "Mod+Ctrl+L".action.move-column-right = { };
            "Mod+Shift+H".action.focus-monitor-left = { };
            "Mod+Shift+J".action.focus-monitor-down = { };
            "Mod+Shift+K".action.focus-monitor-up = { };
            "Mod+Shift+L".action.focus-monitor-right = { };
            "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = { };
            "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = { };
            "Mod+1".action.focus-workspace = 1;
            "Mod+2".action.focus-workspace = 2;
            "Mod+3".action.focus-workspace = 3;
            "Mod+4".action.focus-workspace = 4;
            "Mod+5".action.focus-workspace = 5;
            "Mod+6".action.focus-workspace = 6;
            "Mod+7".action.focus-workspace = 7;
            "Mod+8".action.focus-workspace = 8;
            "Mod+9".action.focus-workspace = 9;
            "Mod+Shift+1".action.move-column-to-workspace = 1;
            "Mod+Shift+2".action.move-column-to-workspace = 2;
            "Mod+Shift+3".action.move-column-to-workspace = 3;
            "Mod+Shift+4".action.move-column-to-workspace = 4;
            "Mod+Shift+5".action.move-column-to-workspace = 5;
            "Mod+Shift+6".action.move-column-to-workspace = 6;
            "Mod+Shift+7".action.move-column-to-workspace = 7;
            "Mod+Shift+8".action.move-column-to-workspace = 8;
            "Mod+U".action.focus-workspace-down = { };
            "Mod+I".action.focus-workspace-up = { };
            "Mod+Ctrl+U".action.move-column-to-workspace-down = { };
            "Mod+Ctrl+I".action.move-column-to-workspace-up = { };
            "Mod+Shift+Page_Down".action.move-workspace-down = { };
            "Mod+Shift+Page_Up".action.move-workspace-up = { };
            "Mod+Shift+U".action.move-workspace-down = { };
            "Mod+Shift+I".action.move-workspace-up = { };
            "Mod+Ctrl+F".action.expand-column-to-available-width = { };
            "Mod+Shift+C".action.center-column = { };
            "Mod+Ctrl+C".action.center-visible-columns = { };
            "Mod+Minus".action.set-column-width = "-10%";
            "Mod+Equal".action.set-column-width = "+10%";
            "Mod+F".action.maximize-column = { };
            "Mod+Shift+F".action.fullscreen-window = { };
            "Mod+V".action.toggle-window-floating = { };
            "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = { };
            "Print".action.screenshot = { };
            "Ctrl+Print".action.screenshot-screen = { };
            "Alt+Print".action.screenshot-window = { };
          };

          # Startup applications
          spawn-at-startup = [
            { command = [ "${pkgs.ashell}/bin/ashell" ]; }
            { command = [ "${pkgs.wbg}/bin/wbg" "${config.stylix.image}" ]; }
          ];

        };
      };

    };

}
