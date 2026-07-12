{ self, inputs, ... }:
{
  flake.nixosModules.system-bootloader =
    { lib, ... }:
    {
      boot.loader.limine.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.efi.efiSysMountPoint = "/boot";
      hardware.enableRedistributableFirmware = true;
      boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
      boot.initrd.kernelModules = [ "" ];
      boot.kernelModules = [ ];
      boot.extraModulePackages = [ ];
    };

  flake.homeModules.system-bootloader = { config, pkgs, lib, ... }: { };


}
