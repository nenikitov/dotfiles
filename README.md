# My humble NixOS user config

## Design

This config is designed to be used with a standalone home-manager installation.

## Installation

1. Install standalone home-manager following these [instructions](https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-standalone)
1. Clone the repository (normally into `.config/home-manager`, but you can do it anywhere)
   ```sh
   git clone https://github.com/nenikitov/dotfiles ${XDG_CONFIG_HOME:-~/.config/home-manager}
   ```
1. Build home configuration
   ```sh
   home-manager switch
   home-manager switch --flake /path/to/cloned/dotfiles # If isn't in `.config/home-manager`
   ```

## Templates

- Ready to be copy and pasted
- Remove comments starting with `###`
- Preserve comments starting with `#`

### Module

All modules must be defined in `modules/<PATH>/<TO>/<MODULE>/default.nix`.

```nix
{libModule, ...}:
libModule.mkEnableModule {
  path = ["<PATH>" "<TO>" "<MODULE>"];
  description = "<DESCRIPTION>";
  options = {
    ### No need for `enable`
    ### Only additional options here
    ### Skip entirely if no additional options needed
  };
  config = {
    ### No need for check for `enable`
    ### Always try to use set
    ### If access to `config` is needed, make this a function
    ### Prefer to use `{configGlobal, ...}:` over `config` argument
  };
}
```

### Host

All hosts must be defined in `hosts/<HOSTNAME>/default.nix` and have a corresponding `host/<HOSTNAME>/hardware.nix` file.

```nix
{customNamespace, ...}: {
  imports = [
    ./hardware.nix
  ];

  # Do not change!
  # Corresponds to the first installed NixOS version
  system.stateVersion = "24.05";

  ### Set if is an EFI system
  boot.loader.efi.canTouchEfiVariables = true;

  ### Select the best profile to use for the machine
  ### Can use multiple profiles
  ${customNamespace} = {
    profiles.desktop.enable = true;
  };

  ### Must-have options
  time.timeZone = "America/Toronto";
}
```

## Inspirations

- [Nebucatnetzer/nixos](https://github.com/Nebucatnetzer/nixos/)
