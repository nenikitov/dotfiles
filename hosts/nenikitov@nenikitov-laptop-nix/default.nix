{
  customNamespace,
  pkgs,
  userName,
  ...
}: {
  # Do not change!
  # Corresponds to the first home-manager version
  home.stateVersion = "24.05";

  ${customNamespace} = {
    profiles.graphical.enable = true;
  };

  home.packages = with pkgs; [
    fastfetch
    ripgrep
  ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        gcc
        libcxx
        python314
        nodejs_24
        luajitPackages.luarocks-nix
        gnumake
        alejandra
        cargo
        nixd
        tree-sitter
        unzip
      ];
    };
  };
}
