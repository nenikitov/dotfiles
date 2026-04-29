{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "a profile with a graphical shell";
      config = {pkgs, ...}: {
        ${self.lib.namespace} = {
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
    };
  };
}
