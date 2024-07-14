{
  lib,
  config,
  ...
}: {
  imports = [
    ./custom.nix
    ./default-aliases.nix
    ./no-useless.nix
  ];

  options = {
    ne.firefox.searchEngines = {
      default = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        example = "DuckDuckGo";
        description = "The default search engine used in the address bar and search bar.";
      };
      privateDefault = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        example = "DuckDuckGo";
        description = "The default search engine used in the Private Browsing.";
      };
    };
  };

  config = {
    programs.firefox.profiles.default.search = {
      force = true;
      default = config.ne.firefox.searchEngines.default;
      privateDefault = config.ne.firefox.searchEngines.privateDefault;
    };
  };
}
