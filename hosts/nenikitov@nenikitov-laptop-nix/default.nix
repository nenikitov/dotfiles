{
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
  ];
}
