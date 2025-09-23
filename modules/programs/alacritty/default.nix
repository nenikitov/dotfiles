{libModule, ...}:
libModule.mkEnableModule {
  path = ["programs" "alacritty"];
  description = "Alacritty terminal emulator";
  config = {
    programs.alacritty = {
      enable = true;
      settings = {
        # TODO: See if I like it if I use transparency
        # colors.transparent_background_colors = true;
        window = {
          dynamic_padding = true;
          padding = {
            x = 6;
            y = 6;
          };
        };
        selection.save_to_clipboard = true;
      };
    };
  };
}
