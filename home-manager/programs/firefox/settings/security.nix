{
  lib,
  config,
  ...
}: {
  options = {
    ne.firefox.settings.security = lib.mkEnableOption "security-related settings";
  };

  config = lib.mkIf config.ne.firefox.settings.security {
    programs.firefox = {
      policies = {
        DisablePasswordReveal = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };
        AutofillCreditCardEnabled = false;
        AutofillAddressEnabled = false;
        Permissions = {
          Notifications = {
            BlockNewRequests = true;
          };
        };
        Preferences = {
          "privacy.globalprivacycontrol.enabled" = true;
        };
      };
      profiles.default.settings = {
        "privacy.donottrackheader.enabled" = true;
      };
    };
  };
}
