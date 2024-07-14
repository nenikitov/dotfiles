{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs = {
    neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
      defaultEditor = true;

      extraPackages = with pkgs; [
        gcc
        python3
        nodejs_22
        luajitPackages.luarocks-nix
        gnumake
        alejandra
        cargo
      ];
    };
  };
}
