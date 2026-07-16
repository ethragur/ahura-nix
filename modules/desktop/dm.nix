{ self
, inputs
, ...
}: {
  flake.nixosModules.dm =
    { config
    , pkgs
    , lib
    , ...
    }: {
      imports = with self.nixosModules; [
        terminal
      ];

      security.pam.services.greetd.enableGnomeKeyring = true;


      services.greetd = {
        enable = true;
        useTextGreeter = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --remember-session --sessions  ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
            user = "greeter";

          };
        };
      };


    };
}

