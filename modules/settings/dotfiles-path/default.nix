{
  config,
  lib,
  libModule,
  ...
}: let
  inherit (lib) types;
in
  libModule.mkModule {
    path = ["settings" "dotfiles_path"];
    options = lib.mkOption {
      type = types.path;
      apply = toString;
      default = "${config.xdg.configHome}/home-manager";
      example = "${config.xdg.configHome}/home-manager";
      description = "Path to home-manager configuration directory";
    };
  }
