{ self
, inputs
, ...
}: {
  flake.nixosModules.theme =
    { lib
    , pkgs
    , ...
    }: {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];

      stylix = {
        enable = true;
        homeManagerIntegration.autoImport = true;
        homeManagerIntegration.followSystem = true;
        autoEnable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
        cursor = {
          name = "Quintom_Ink";
          package = "${pkgs.quintom-cursor-theme}";
          size = 32;
        };
        fonts = {
          serif = {
            package = pkgs.noto-fonts;
            name = "Noto Serif";
          };

          sansSerif = {
            package = pkgs.noto-fonts;
            name = "Noto Sans";
          };

          monospace = {
            package = pkgs.nerd-fonts.fira-code;
            name = "Fira Code";
          };

          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
          sizes = {
            applications = 12;
            desktop = 12;
            popups = 12;
          };
        };
      };
    };
}

