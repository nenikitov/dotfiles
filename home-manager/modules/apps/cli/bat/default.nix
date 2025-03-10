{
  config,
  lib,
  ...
}: let
  cfg = config.ne.apps.bat;
in {
  options.ne.apps.bat = {
    enable = lib.mkEnableOption "bat file previewer";
  };
  config = lib.mkIf cfg.enable {
    programs = {
      bat = {
        enable = true;
        config = {
          paging = "always";
        };
      };
    };
  };
}
