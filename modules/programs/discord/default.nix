{libModule, ...}:
libModule.mkEnableModule {
  path = ["programs" "discord"];
  description = "Discord chat application";
  config = {
    programs.discord = {
      enable = true;
      settings = {
        MIN_WIDTH = 0;
        MIN_HEIGHT = 0;
      };
    };
  };
}
