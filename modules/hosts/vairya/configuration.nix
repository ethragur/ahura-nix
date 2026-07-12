{ self
, inputs
, ...
}: {
  flake.nixosModules.vairyaConfiguration =
    { lib
    , ...
    }: {
      imports = with self.nixosModules; [
        system-desktop
        system-bootloader
        mithra
      ];

      nixpkgs.hostPlatform = lib.mkDefault
        "x86_64-linux";


      virtualisation.vmVariantWithBootLoader = {
        virtualisation = {
          useEFIBoot = true;
          diskSize = 8192;
          memorySize = 2048;
        };
      };
      virtualisation.vmVariant = {
        virtualisation.qemu.options = [
          "-vga none"
          "-device virtio-vga-gl"
          "-display gtk,gl=on"
        ];
      };

      hardware.graphics.enable = true;

      fileSystems."/" = {
        device = "/dev/vda2"; # a partition, not the whole disk
        fsType = "ext4";
      };
      fileSystems."/boot" = {
        device = "/dev/vda1";
        fsType = "vfat";
      };


    };
}
