{  pkgs, userName, customNamespace, ... }:

{
  home.username = userName;
  home.homeDirectory = "/home/${userName}";

  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05";


  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    discord
    fastfetch
    neovim
    ripgrep
  ];

  "${customNamespace}" = {
    programs = {
      git.enable = true;
      firefox.enable = true;
    };
  };
}
