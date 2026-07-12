{ self
, inputs
, ...
}:
{
  # default settings needed for all nixosConfigurations

  flake.nixosModules.system-basic =
    { pkgs, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.self.nixosModules.shell
        inputs.self.nixosModules.helix
      ];

      ## Nix Settings
      nixpkgs.config.allowUnfree = true;
      system.stateVersion = "26.11";

      nixpkgs.config.permittedInsecurePackages = [
      ];

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        download-buffer-size = 1024 * 1024 * 1024;

        trusted-users = [
          "root"
          "@wheel"
        ];
      };

      time.timeZone = "Europe/Vienna";
      i18n.defaultLocale = "en_US.UTF-8";

      security.sudo = { enable = false; };

      security.doas = {
        enable = true;
        wheelNeedsPassword = false;
      };

      services.resolved.enable = true;

      environment.systemPackages = with pkgs; [
        wget
        curl
        git
        p7zip
        htop
        unrar
        jq
      ];

      # Make /etc/hosts editable
      environment.etc.hosts.mode = "0644";

      home-manager = {
        verbose = true;
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "backup";
        backupCommand = "rm";
        overwriteBackup = true;
      };

      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
      };

      nix.extraOptions = ''
        warn-dirty = false
        keep-outputs = true
      '';

      networking = {
        nftables.enable = true;
        nameservers = [ "9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9" ];
        firewall = {
          enable = true;
          allowedTCPPorts = [ 222 ];
        };
      };

      home-manager.sharedModules = [
        inputs.self.homeModules.system-basic
      ];

    };

  flake.homeModules.system-basic =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      home.homeDirectory =
        if pkgs.stdenv.isDarwin then
          (lib.mkForce "/Users/${config.home.username}")
        else
          "/home/${config.home.username}";

      home.packages = [
      ];
      home.stateVersion = "26.11";
    };
}
