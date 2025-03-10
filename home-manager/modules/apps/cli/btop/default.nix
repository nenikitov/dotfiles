{
  config,
  lib,
  ...
}: let
  cfg = config.ne.apps.btop;
in {
  options.ne.apps.btop = {
    enable = lib.mkEnableOption "btop system monitor";
  };
  config = lib.mkIf cfg.enable {
    programs = {
      btop = {
        enable = true;
        settings = {
          theme_background = false;
          vim_keys = true;
        };
      };
    };
  };
}
