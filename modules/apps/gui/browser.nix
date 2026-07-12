{ self, inputs, ... }:
{
  flake.nixosModules.browser =
    { pkgs, ... }:
    {
      imports = with self.nixosModules; [
      ];

      home-manager.sharedModules = [
        inputs.self.homeModules.browser
      ];
    };

  flake.homeModules.browser =
    { pkgs, ... }:
    {
      imports = [ inputs.zen-browser.homeModules.beta ];

      stylix.targets.zen-browser.profileNames = [ "default" ];
      programs.zen-browser = {
        enable = true;
        setAsDefaultBrowser = true;
        profiles = {
          default = {
            isDefault = true;
            settings = {
              "media.ffmpeg.vaapi.enabled" = true;
            };
          };
        };
        policies = {
          AutofillAddressEnabled = true;
          AutofillCreditCardEnabled = false;
          DisableAppUpdate = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
        };

      };
    };

  perSystem = { pkgs, lib, ... }:
    let
      mkNixPak = inputs.nixpak.lib.nixpak {
        inherit (pkgs) lib;
        inherit pkgs;
      };

      wrap = package: config: (mkNixPak {
        config = { sloth, ... }:
          lib.recursiveUpdate
            {
              app.package = package;
              bubblewrap.network = true;
            }
            (config sloth);
      }).config.script;
    in
    {
      packages = {
        zen-browser = wrap
          inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
          (sloth: {
            dbus.enable = true;
            bubblewrap.network = true;
            bubblewrap.shareIpc = true;

            # Wayland support
            bubblewrap.sockets.wayland = true;

            # Audio (PipeWire + PulseAudio)
            bubblewrap.sockets.pipewire = true;
            bubblewrap.sockets.pulse = true;

            # Full device access (like --device=all, --socket=pcsc, --socket=cups)
            bubblewrap.apivfs.dev = true;
            bubblewrap.apivfs.proc = true;

            # Persist .zen config directory in home
            bubblewrap.bind.rw = [
              (sloth.concat' sloth.homeDir "/.zen")
              (sloth.concat' sloth.homeDir "/.cache/zen")
              (sloth.concat' sloth.homeDir "/Downloads")
            ];

            # Read-only bindings
            bubblewrap.bind.ro = [
              "/run/.heim_org.h5l.kcm-socket"
              (sloth.concat' sloth.runtimeDir "/speech-dispatcher")
            ];

            # Environment variable from flatpak
            bubblewrap.env.DICPATH = "/usr/share/hunspell";

            # Firefox/zen still checks XAUTHORITY even on Wayland (GLX fallback)
            bubblewrap.env.XAUTHORITY = "/dev/null";

            # Security: child dies with parent
            bubblewrap.dieWithParent = true;
          });
      };
    };
}
