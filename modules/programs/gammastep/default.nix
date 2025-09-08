{libModule, ...}:
libModule.mkEnableModule {
  path = ["programs" "gammastep"];
  description = "gammastep screen temperature control";
  config = {
    services.gammastep = {
      enable = true;

      dawnTime = "06:00-07:00";
      duskTime = "20:00-21:00";

      temperature = {
        # Neutral temperature according to `man gammastep`, but it's not a default for whatever reason
        day = 6500;
        night = 3500;
      };
    };
  };
}
