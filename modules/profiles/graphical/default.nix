{libModule, ...}:
libModule.mkEnableModule {
  path = ["profiles" "graphical"];
  description = "a graphical profile. Enables `minimal` too";
  config = {namespace, ...}: {
    "${namespace}" = {
      profiles.minimal.enable = true;

      programs = {
        alacritty.enable = true;
        librewolf.enable = true;
        niri.enable = true;
        rofi.enable = true;
      };
    };
  };
}
