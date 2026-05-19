{
  customNamespace,
  pkgs,
  ...
}: {
  # Do not change!
  # Corresponds to the first home-manager version
  home.stateVersion = "25.05";

  programs.obs-studio.enable = true;
  # TODO: enabling home-manager module breaks the entire thing and forces the use of nix for config
  # I might not need anything beyond deploying symlinks and maybe generating monitors file
  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   configType = "hyprlang";
  #   systemd.enable = false;
  #   settings = {
  #     "$mod" = "SUPER";
  #     bind = [
  #       "$mod, C, killactive"
  #       "$mod, RETURN, exec, alacritty"
  #       "$mod SHIFT, RETURN, exec, rofi -show drun"
  #     ];
  #   };
  # };

  ${customNamespace} = {
    profiles.graphical.enable = true;

    # TODO: Move this into separate profiles
    programs.librewolf.searchEngines = {
      linux.enable = true;
      programming.enable = true;
      game.enable = true;
    };

    settings.monitors = [
      {
        name = "Ancor Communications Inc MG248 G9LMQS024781";
        primary = true;
        mode = {
          width = 1920;
          height = 1080;
          refresh = 143.981;
        };
        position = {
          x = 0;
          y = 0;
        };
      }
      {
        name = "ASUSTek COMPUTER INC VG245 KCLMQS015128";
        mode = {
          width = 1920;
          height = 1080;
          refresh = 75.001;
        };
        position = {
          x = 1920;
          y = 0;
        };
      }
    ];
  };

  home.packages = with pkgs; [
    fastfetch
    ripgrep
  ];
}
