{
  customNamespace,
  pkgs,
  userName,
  ...
}: {
  # Do not change!
  # Corresponds to the first home-manager version
  home.stateVersion = "24.05";

  "${customNamespace}" = {
    profiles.graphical.enable = true;
  };

  home.packages = with pkgs; [
    fastfetch
    neovim
    ripgrep
  ];
}
