{
  libModule,
  userName,
  ...
}:
libModule.mkEnableModule {
  path = ["profiles" "minimal"];
  description = "a bare-bones, minimal profile";
  config = {
    configGlobal,
    namespace,
    ...
  }: {
    home = {
      username = userName;
      homeDirectory = "/home/${configGlobal.home.username}";
    };

    nixpkgs.config.allowUnfree = true;

    programs.home-manager.enable = true;
    news.display = "silent";

    "${namespace}" = {
      programs = {
        brightnessctl.enable = true;
        git.enable = true;
        btop.enable = true;
      };
      settings = {
        garbageCollection.enable = true;
      };
    };
  };
}
