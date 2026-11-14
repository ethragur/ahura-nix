{ self, lib, inputs, ... }:
{
  # perSystem =
  #   { pkgs, ... }:
  #   let
  #     zfsCompatibleKernelPackages = lib.filterAttrs
  #       (
  #         name: kernelPackages:
  #           (builtins.match "linux_[0-9]+_[0-9]+" name) != null
  #           && (builtins.tryEval kernelPackages).success
  #           && (!kernelPackages.zfs.meta.broken)
  #       )
  #       pkgs.linuxKernel.packages;
  #     latestKernelPackage = lib.last (
  #       lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
  #         builtins.attrValues zfsCompatibleKernelPackages
  #       )
  #     );
  #   in
  #   {
  #     # if you need to expose this per-system, e.g. via _module.args or similar
  #   };

  flake.nixosModules.zfs =
    { pkgs, lib, config, ... }:
    {
      # boot.kernelPackages = lib.mkDefault (
      #   let
      #     zfsCompatibleKernelPackages = lib.filterAttrs
      #       (
      #         name: kernelPackages:
      #           (builtins.match "linux_[0-9]+_[0-9]+" name) != null
      #           && (builtins.tryEval kernelPackages).success
      #           && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
      #       )
      #       pkgs.linuxKernel.packages;
      #   in
      #   lib.last (
      #     lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      #       builtins.attrValues zfsCompatibleKernelPackages
      #     )
      #   )
      # );
      boot.kernelPackages = pkgs.linuxPackages;
      boot.supportedFilesystems = [ "zfs" ];
      boot.zfs.forceImportRoot = false;
      systemd.services.zfs-mount.enable = false;
    };
}
