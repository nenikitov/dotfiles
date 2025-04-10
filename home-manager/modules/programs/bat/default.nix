{
  config,
  lib,
  ...
}: let
  cfg = config.ne.programs.bat;
in {
  options.ne.programs.bat = {
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
