# Ahura — NixOS Configuration Repository

## Project Overview

This is a personal NixOS configuration repository managed with `flake-parts` and `import-tree`. It uses a **dendritic module architecture** where modules can import other modules, forming a tree-like hierarchy. The goal is a clean, secure, and easily expandable system configuration.

## Key Technologies

- **Nix Flakes** + **flake-parts** — modular build system
- **import-tree** — auto-discovers modules from the directory structure
- **Home Manager** — user environment managed alongside NixOS
- **Nixpak** — sandboxed application packaging via bubblewrap
- **Dendritic modules** — modules that import other modules (see `example.nix`)
- **Stylix** — theming (base16, fonts, cursors)
- **Sway** — Wayland window manager
- **agenix** — secrets management
- **NH** — Nix helper for easy rollbacks and switches

## Directory Structure

```
modules/
├── parts.nix          ← flake-parts root: defines systems, imports home-manager, do not edit!
├── apps/           ← App directory
│   └── gui/        ← Graphical Apps
│   └── cli/        ← CLI Apps
├── core/
│   └── theme.nix      ← Stylix theming (Rose Pine, fonts, cursors)
├── desktop/
│   ├── dm.nix         ← Display manager (regreet + greetd)
│   ├── wayland.nix    ← Wofi launcher, swaylock, waybar config
│   ├── sway.nix       ← Sway WM configuration
│   └── terminal.nix   ← Alacritty terminal
├── system/
│   ├── basic.nix      ← Base NixOS + HM config (time, i18n, doas, nh, packages)
│   └── desktop.nix    ← Desktop stack (pipewire, xdg portals, imports basic)
├── factory/
│   └── user.nix       ← User factory: generates nixosModules + homeModules from username
├── hosts/
│   └── vairya/        ← Per-host configurations
│       ├── default.nix     ← Declares nixosConfiguration
│       └── configuration.nix  ← Imports system modules + user modules
├── users/
│   └── mithra/        ← Per-user configurations (uses factory)
│       └── default.nix
└── services/          ← System services (add as needed)
```

## Dendritic Module Pattern

Modules are designed to be composable — they import other modules to build up a configuration. See `example.nix` for the template:

```nix
{ self, inputs, ... }:
{
  flake.nixosModules.myModule = { pkgs, ... }: {
    imports = with self.nixosModules; [
      # Import other dendritic modules
      system-basic
    ];

    home-manager.sharedModules = [
      inputs.self.homeModules.myModule
    ];

    # NixOS options go here
  };

  flake.homeModules.myModule = { config, pkgs, lib, ... }: {
    # Home Manager options go here
  };
}
```

**Rules:**
- Module names use kebab-case in filenames but camelCase in `flake.*Modules` names
- Every `nixosModule` should have a corresponding `homeModule`
- Create new modules as a simple file called `<<modulename>>.nix` in the correct directory
- Use `imports` to compose modules hierarchically
- Always reference `self.nixosModules` and `inputs.self.homeModules` for internal imports
- Always read ./example.nix when creating new modules.

## User Factory

Users are created via the factory in `modules/factory/user.nix`:

```nix
# In a user's default.nix:
let
  base = self.factory.user "username" isAdmin;  # isAdmin = true/false
in
{
  flake.nixosModules.username = { ... }: {
    imports = [ base.nixosModules.username ];
    # Override user-specific options (e.g., initialPassword)
  };

  flake.homeModules.username = { ... }: {
    imports = [ base.homeModules.username ];
    # Add user-specific packages and settings
  };
}
```

The factory automatically sets up:
- NixOS user with fish shell
- Home Manager user with shared imports
- Wheel group membership (if admin)

## Nixpak Sandboxed Packages

Sandboxed apps are defined in `modules/packages/bash.nix` (and can be split further). The pattern:

```nix
perSystem = { pkgs, lib, ... }:
  let
    mkNixPak = inputs.nixpak.lib.nixpak { inherit (pkgs) lib; inherit pkgs; };
    wrap = package: config: (mkNixPak {
      config = { sloth, ... }:
        lib.recursiveUpdate
          { app.package = package; bubblewrap.network = false; }
          (config sloth);
    }).config.script;
  in
  {
    packages = {
      myApp = wrap pkgs.myApp (sloth: {
        dbus.enable = true;
        bubblewrap.network = true;
        bubblewrap.bind.rw = [ (sloth.concat' sloth.homeDir "/Downloads") ];
      });
    };
  };
};
```

Nixpak packages are exposed in `self.packages.<system>.<name>` and can be used in home modules.

## Host Configuration

Each host lives under `modules/hosts/<hostname>/`:
- `default.nix` — declares the `nixosConfiguration` via `nixosSystem`
- `configuration.nix` — imports the right combination of modules

## Adding New Modules

1. Create a new file under the appropriate directory (e.g., `modules/services/new-service.nix`)
2. Follow the dendritic pattern from `example.nix`
3. Import it from a parent module (e.g., `system-desktop.nix` or a host config)
4. If it needs sandboxed packages, add them to `perSystem` in the appropriate file

## Building & Deploying

After creating new files you need to add them to git

`git add modules/myModule.nix`

To test the current configuration use
`nix flake check --no-build`


## Conventions

- Use `lib.mkDefault` for options that should be overridable
- Use `lib.mkForce` only when you need to override a default
- Keep modules focused — one responsibility per file
- Services go in `modules/services/`, desktop components in `modules/desktop/`, core system in `modules/system/`
- Secrets are managed via agenix (input declared but not yet used)
