{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "a profile with a graphical shell";
      config = {pkgs, ...}: {
        ${self.lib.namespace} = {
          programs = {
            alacritty.enable = true;
            librewolf.enable = true;
            niri.enable = true;
            rofi.enable = true;
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
        home.pointerCursor = {
          enable = true;
          gtk.enable = true;

          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 16;
        };
        gtk = rec {
          enable = true;
          gtk4 = {
            inherit theme iconTheme;
          };

          colorScheme = "dark";
          iconTheme = {
            name = "Fluent dark";
            package = pkgs.fluent-icon-theme;
          };
          theme = {
            name = "Fluent-Dark-compact";
            package = pkgs.fluent-gtk-theme;
          };
        };
        qt = {
          enable = true;
          platformTheme.name = "gtk3";
        };
      };
    };
    nixosModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "a profile with a graphical shell";
      config = {pkgs, ...}: {
        ${self.lib.namespace} = {
          hardware = {
            audio.enable = true;
            bluetooth.enable = true;
            printing.enable = true;
          };

          programs = {
            plymouth.enable = true;
            niri.enable = true;
          };
        };

        services.xserver = {
          enable = true;
          excludePackages = [pkgs.xterm];
        };
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };
      };
    };
  };
}
