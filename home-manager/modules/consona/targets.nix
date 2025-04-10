{
  config,
  lib,
  ...
}: let
  cfg = config.ne.consona;
in {
  options.ne.consona = {
    enable = lib.mkEnableOption "Consona theming engine";
  };
  config = lib.mkIf cfg.enable {
    consona = {
      enable = true;
      autoEnable = true;
      targets = {
        btop.fullcolor = false;
      };
    };
  };
}
