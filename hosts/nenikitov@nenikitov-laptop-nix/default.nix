{
  config,
  customNamespace,
  pkgs,
  ...
}: {
  # Do not change!
  # Corresponds to the first home-manager version
  home.stateVersion = "24.05";

  ${customNamespace} = {
    profiles.graphical.enable = true;

    # TODO: Move this into separate profiles
    programs.librewolf.searchEngines = {
      linux.enable = true;
      programming.enable = true;
      game.enable = true;
    };
  };

  home.packages = with pkgs; [
    fastfetch
    ripgrep
    traceroute
    unixtools.ifconfig
    wireshark
    python3
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
      package = pkgs.fluent-gtk-theme;
      name = "Fluent-Dark-compact";
    };
  };

  qt = {
    enable = true;
    #style.name = "adwaita-dark";
    platformTheme.name = "gtk3";
    #qt6ctSettings = {
    #  Appearance = {
    #    icon_theme = "Fluent dark";
    #  };
    #};
  };


  /*
  gtk = rec {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
    };
    colorScheme = "dark";
    theme = {
      package = pkgs.fluent-gtk-theme;
      name = "Fluent dark";
    };
    iconTheme = {
      package = pkgs.fluent-icon-theme;
      name = "Fluent dark";
    };
    gtk4 = {
      inherit theme iconTheme;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
  */
}
