{libModule, ...}:
libModule.mkEnableModule {
  path = ["profiles" "graphical"];
  description = "a graphical profile. Enables `minimal` too";
  config = {namespace, ...}: {
    ${namespace} = {
      profiles.minimal.enable = true;

      programs = {
        alacritty.enable = true;
        cliphist.enable = true;
        discord.enable = true;
        gammastep.enable = true;
        librewolf.enable = true;
        niri.enable = true;
        rofi.enable = true;
        wl-clipboard.enable = true;
      };
    };
  };
}
