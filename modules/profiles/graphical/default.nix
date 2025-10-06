{
  pkgs,
  libModule,
  ...
}:
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

    # TODO: Make this a separate module or handle with a theming engine
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = ["Mononoki" "Symbols Nerd Font"];
        sansSerif = ["Jost*"];
        serif = ["Jost*"];
      };
    };
    home.packages = with pkgs; [
      noto-fonts-color-emoji
      nerd-fonts.symbols-only
      mononoki
      jost
    ];
  };
}
