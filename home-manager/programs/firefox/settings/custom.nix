{
  lib,
  config,
  ...
}: {
  options = {
    ne.firefox.settings.custom = {
      minimalSuggestions = lib.mkEnableOption "removal of useless suggestions options";
      restoreSession = lib.mkEnableOption "openning of previous windows and tabs";
    };
  };

  config = let
    custom = config.ne.firefox.settings.custom;
  in {
    programs.firefox.policies = lib.mkMerge [
      (lib.mkIf
        custom.minimalSuggestions
        {
          FirefoxSuggest = {
            WebSuggestions = true;
            SponsoredSuggestions = false;
            ImproveSuggest = false;
            Locked = true;
          };
          Preferences = {
            "browser.urlbar.suggest.topsites" = false;
          };
        })
      (lib.mkIf
        custom.restoreSession
        {
          Homepage = {
            StartPage = "previous-session";
          };
        })
    ];
  };
}
