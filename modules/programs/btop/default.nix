{libModule, ...}:
libModule.mkEnableModule {
  path = ["programs" "btop"];
  description = "btop system monitor";
  config = {
    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
  };
}
