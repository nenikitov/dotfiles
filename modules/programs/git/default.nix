{
  mkModule,
  ...
}:
mkModule {
  path = ["programs" "git"];
  description = "git version control tool";
  config = {
    programs.git = {
      enable = true;
      delta.enable = true;
    };
  };
}
