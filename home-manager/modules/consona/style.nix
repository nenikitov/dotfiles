{pkgs, ...}: {
  consona = {
    fonts = {
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
      fallback = {
        name = "Symbols Nerd Font";
        package = pkgs.nerd-fonts.symbols-only;
      };
      monospace = {
        name = "Mononoki";
        package = pkgs.mononoki;
      };
      sansSerif = {
        name = "Jost*";
        package = pkgs.jost;
      };
      serif = {
        name = "Jost*";
        package = pkgs.jost;
      };
    };

    colors = {
      palette = {
        primary = {
          bg = "#171A22";
          fg = "#B7C2C8";
        };
        normal = {
          black = "#20232B";
          red = "#DA5261";
          green = "#56B877";
          yellow = "#DB8878";
          blue = "#4788F0";
          magenta = "#AF6ADB";
          cyan = "#49B2BB";
          white = "#8B909D";
        };
        standout = {
          black = "#555A66";
          red = "#FA788E";
          green = "#A7FA9C";
          yellow = "#F9C097";
          blue = "#81B5FF";
          magenta = "#D9A1FF";
          cyan = "#69F3FF";
          white = "#DDEBF2";
        };
      };

      code = {
        comment = {
          color = "standoutBlack";
          italic = true;
        };
        literalText.color = "standoutYellow";
        literalNumber.color = "yellow";
        literalLanguage.color = "yellow";
        literalEscape.color = "cyan";
        typePrimitive.color = "yellow";
        typeComplex.color = "standoutYellow";
        typeModule.color = "standoutYellow";
        functionNative.color = "cyan";
        functionMeta.color = "blue";
        variable.color = "red";
        keywordLanguage.color = "magenta";
        keywordOperator.color = "white";
        keywordDelimiter.color = "white";
      };

      ui = {
        selection = {
          color = "blue";
          opacity = 0.2;
        };
        match = {
          color = "standoutYellow";
          opacity = 0.2;
        };
        matchCurrent = {
          color = "yellow";
          opacity = 0.4;
        };
      };
    };
  };
}
