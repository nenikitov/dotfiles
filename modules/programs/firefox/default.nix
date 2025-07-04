# TODO: look into floorp browser
# Advantages
# - Less configuring, less crap is on by default
# - More features?
# Disadvantages
# - Is based on ESR, less up-to-date
# - No tab groups (maybe added in v12)
# Notes
# - Has the same home-manager settings as firefox, just under the key `floorp` - should be easy to migrate
{
  lib,
  mkModule,
  ...
}:
mkModule {
  path = ["programs" "firefox"];
  description = "Firefox web-browser";
  options = {
    searchEngines = {
      linux = lib.mkEnableOption "addition of linux-related search engines" // {default = true;};
    };
    extensions = {
      enable = lib.mkEnableOption "addition of linux-related search engines" // {default = true;};
    };
  };
  config = {configModule, ...}: {
    programs.firefox = {
      enable = true;
    };
  };
}
