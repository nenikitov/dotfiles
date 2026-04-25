# My humble NixOS system and user configs.

## Design

This config includes both system and home configurations.

The system config is very minimal by design.
It contains only system-level options, a few very necessary programs, and services.

Almost all of my configuration is done in user-level through home-manager and is designed for standalone installation.

## Installation

1. Install standalone home-manager following these [instructions](https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-standalone)
1. Clone the repository
   ```sh
   # My preferred places but you can do it anywhere
   sudo git clone https://github.com/nenikitov/dotfiles /etc/nixos
   git clone https://github.com/nenikitov/dotfiles "${XDG_CONFIG_HOME:-~/.config/home-manager}"
   ```
1. Build configurations
   ```sh
   sudo nixos-rebuild switch
   home-manager switch
   ```

## Templates

- Ready to be copy and pasted
- Remove comments starting with `###`
- Preserve comments starting with `#`

### Module

All modules must be defined in `modules/<PATH>/<TO>/<MODULE>/default.nix`.
They follow dendritic pattern, allowing each to expose any flake output, but prefer to use `packages`, `homeModules`, and `nixosModules`.
Home configuration is preferred over system.

```nix
{self, ...}: {
  flake = {
    homeModules = self.lib.mkModule {
      path = __curPos;
      options = {
        ### No need for `enable`
        ### Only additional options here
        ### Skip entirely if no additional options needed
      };
      config = {
        ### No need for check for `enable`
        ### Always try to use set
        ### If access to `config` is needed, make this a function
      };
    };
  };
}
```

### Homes

All home configurations must be defined in `homes/<USER>@<HOST>/default.nix`.

```nix
{self, ...}: {
  perSystem = {pkgs, ...}:
    self.lib.mkHome {
      inherit pkgs;
      userName = "<USER>";
      hostName = "<HOST>";
    } {
      imports = [
        ### Minimal profile (`self.homeModules.profile_minimal`) is already enabled.
        ### Any other modules through `self.homeModules`.
      ];

      # Do not change!
      # Corresponds to the first home-manager version installed on this machine.
      home.stateVersion = "<HOME_STATE>";

      ${self.lib.namespace} = {
        ### Any configuration options for modules.
      };
    };
}
```

## Inspirations

- [Nebucatnetzer/nixos](https://github.com/Nebucatnetzer/nixos)
- [Doc-Steve/dendritic-design-with-flake-parts](https://github.com/Doc-Steve/dendritic-design-with-flake-parts)
