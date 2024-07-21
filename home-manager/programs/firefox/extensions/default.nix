{
  lib,
  config,
  ...
} @ attrs: let
  makeExtension = {
    name,
    settings,
    storeId ? null,
    url ? null,
  }: let
    install_url =
      if url != null && storeId == null
      then url
      else if storeId != null && url == null
      then "https://addons.mozilla.org/en-US/firefox/downloads/latest/${storeId}/latest.xpi"
      else throw "Exactly one of `storeId` or `url` for extension ${name} must be provided, not both or neither";
  in {
    ExtensionSettings = {
      "${name}" = {
        inherit install_url;
        installation_mode = "force_installed";
      };
    };
    "3rdparty".Extensions = {
      "${name}" = settings;
    };
  };
  extensions = [
    ./ublock-origin.nix
    ./dark-reader.nix
  ];
in {
  programs.firefox.policies = lib.mkMerge (lib.map (e: makeExtension (import e attrs)) extensions);
}
