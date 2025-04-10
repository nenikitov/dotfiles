{
  config,
  lib,
  ...
}: let
  cfg = config.ne.programs.git;
in {
  options.ne.programs.git = {
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
