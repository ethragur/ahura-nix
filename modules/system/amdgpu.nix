{ self, inputs, ... }:
{
  flake.nixosModules.amdgpu =
    { pkgs, lib, ... }:
    {
      nixpkgs.config.allowUnfree = true;

      boot.kernelModules = [ "kvm-amd" "amdgpu" ];

      hardware.graphics.extraPackages = with pkgs; [
        rocmPackages.rocm-runtime
        rocmPackages.rocminfo
        rocmPackages.clr
        rocmPackages.clr.icd
      ];

      services.xserver.videoDrivers = [ "amdgpu" ];

      systemd.tmpfiles.rules = [
        "L+    /opt/rocm/hip -    -    -    -    ${pkgs.rocmPackages.clr}"
      ];

      programs.corectrl.enable = true;

      boot.kernelParams = [
        "amdgpu.vm_fragment_size=20000"
        "amdgpu.vm_update_mode=3"
        "amdgpu.cwsr_enable=0"
      ];

      hardware.amdgpu.overdrive = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };

      hardware.graphics.enable = true;
      hardware.graphics.enable32Bit = true;
    };
}
