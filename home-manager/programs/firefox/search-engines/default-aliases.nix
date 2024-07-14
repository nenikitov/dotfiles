{
  lib,
  config,
  ...
}: {
  options = {
    ne.firefox.searchEngines.defaultAliases = lib.mkEnableOption "shorter aliases to default search engines";
  };

  config = lib.mkIf config.ne.firefox.searchEngines.defaultAliases {
    programs.firefox.profiles.default.search.engines = {
      "Google".metaData.alias = "@gg";
      "Wikipedia (en)".metaData.alias = "@wiki";
    };
  };
}
