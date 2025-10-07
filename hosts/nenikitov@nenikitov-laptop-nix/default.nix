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
    settings.dotfiles_path = "${config.xdg.configHome}/home-manager-new";
  };

  home.packages = with pkgs; [
    fastfetch
    ripgrep
  ];
}
