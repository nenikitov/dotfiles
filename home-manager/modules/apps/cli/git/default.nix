{
  config,
  lib,
  ...
}: let
  cfg = config.ne.apps.git;
in {
  options.ne.apps.git = {
    enable = lib.mkEnableOption "git version control tool";
  };
  config = lib.mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        userName = "nenikitov";
        extraConfig = {
          init.defaultBranch = "main";
        };
      };
    };
  };
}
