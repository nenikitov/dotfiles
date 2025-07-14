{
  lib,
  libModule,
  pkgs,
  ...
}:
libModule.mkEnableSubmodule {
  path = ["programs" "librewolf" "search"];
  pathParent = ["programs" "librewolf"];
  options = {
    default = lib.mkOption {
      description = "Deafult search engine to use.";
      default = "ddg";
      example = "ddg";
      type = lib.types.str;
    };
    linux = {
      enable = lib.mkEnableOption "addition of linux-related search engines" // {default = true;};
      nixVersion = lib.mkOption {
        description = "Channel or version that NixOS follows";
        default = "unstable";
        example = "25.05";
        type = lib.types.str;
      };
      homeManagerVersion = lib.mkOption {
        description = "Channel or version that Home Manager follows";
        default = "unstable";
        example = "25.05";
        type = lib.types.str;
      };
    };
    games = {
      enable = lib.mkEnableOption "addition of game-related search engines" // {default = true;};
    };
  };
  config = {configModule, ...}: {
    programs.librewolf = lib.mkMerge [
      # Remove useless
      {
        policies = {
          Remove = [
            "Amazon.com"
            "Bing"
            "eBay"
            "Twitter"
            "Wikipedia (en)"
          ];
          Add = [];
        };
      }
      # Set default
      {
        # HACK: Librewolf's deafult policy overwrites user's search engine without this
        policies.SearchEngines.Default = configModule.default;
      }
    ];
  };
}
