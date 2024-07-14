{
  lib,
  config,
  ...
}: {
  options = {
    ne.firefox.settings.noUseless = lib.mkEnableOption "removal of useless features and telemetry";
  };

  config = lib.mkIf config.ne.firefox.settings.noUseless {
    programs.firefox.policies = {
      # Auto update, useless with NixOS
      DisableAppUpdate = true;
      DisableSystemAddonUpdate = true;
      ExtensionUpdate = false;
      # Telemetry
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      # Features
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableSetDesktopBackground = true;
      DisableFeedbackCommands = true;
      NoDefaultBookmarks = true;
      DisableForgetButton = true;
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
        Locked = true;
      };
    };
  };
}
