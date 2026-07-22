{self, ...}: {
  flake = {
    nixosModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "Plymouth splash screen";
      config = {pkgs, ...}: {
        boot.plymouth = {
          enable = true;
          # TODO: make my own theme
          theme = "spinner_alt";
          themePackages = with pkgs; [
            (adi1090x-plymouth-themes.override {
              selected_themes = ["spinner_alt"];
            })
          ];
        };
      };
    };
  };
}
