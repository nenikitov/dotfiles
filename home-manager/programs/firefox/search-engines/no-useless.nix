{
  lib,
  config,
  ...
}: {
  options = {
    ne.firefox.searchEngines.noUseless = lib.mkEnableOption "removal of useless search engines";
  };
  config = lib.mkIf config.ne.firefox.searchEngines.noUseless {
    programs.firefox.profiles.default.search.engines = {
        "Bing".metaData.hidden = true;
        "eBay".metaData.hidden = true;
    };
  };
}
