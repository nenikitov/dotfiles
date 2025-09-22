{libModule, ...}:
libModule.mkEnableModule {
  path = ["programs" "rofi"];
  description = "rofi application launcher";
  config = {
    programs.rofi = {
      enable = true;
    };
  };
}
