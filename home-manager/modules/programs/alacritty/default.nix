{
  config,
  lib,
  ...
}: let
  cfg = config.ne.programs.alacritty;
in {
  options.ne.programs.alacritty = {
    enable = lib.mkEnableOption "Alacritty terminal emulator";
  };
  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
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
