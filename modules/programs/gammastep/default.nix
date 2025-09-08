{
  libModule,
  ...
}:
libModule.mkEnableModule {
  path = ["programs" "gammastep"];
  description = "gammastep screen temperature control";
  config = {
    services.gammastep = {
      enable = true;

      dawnTime = "06:00-07:00";
      duskTime = "20:00-21:00";

      temperature = {
        night = 3500;
      };
    };
  };
}
