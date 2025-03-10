{pkgs, ...}: {
  imports = [
    ./modules

    ./programs/firefox
    ./programs/neovim.nix
    ./programs/zsh
  ];

  home.username = "nenikitov";
  home.homeDirectory = "/home/nenikitov";

  ne = {
    consona.enable = true;
    fonts.enable = false;
    apps = {
      alacritty.enable = true;
      btop.enable = true;
      git.enable = true;
      imv.enable = true;
      oh-my-posh.enable = true;
      bat.enable = true;
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    neofetch
    wl-clipboard
    discord
    zip
    unzip
    ripgrep
    python311
    moar
    # spotify
    figma-linux
    pureref
    rustup
    gcc
    r2modman
  ];

  programs = {
    home-manager.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Garbage collection
  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than +5";
  };
}
