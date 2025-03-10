{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ne.fonts;
in {
  options.ne.fonts = {
    enable = lib.mkEnableOption "Custom fonts";
  };
  config = lib.mkIf cfg.enable {
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Mononoki" "Symbols Nerd Font"];
        sansSerif = ["Jost*" "Symbols Nerd Font"];
        serif = ["Jost*" "Symbols Nerd Font"];
      };
    };

    home.packages = with pkgs; [
      mononoki
      jost
      comfortaa
      corefonts
      vistafonts
      nerd-fonts.symbols-only
    ];
  };
}
