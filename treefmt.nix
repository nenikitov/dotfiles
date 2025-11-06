{pkgs, ...}: {
  projectRootFile = "flake.nix";

  programs = {
    actionlint.enable = true;
    alejandra.enable = true;
    mdformat = {
      enable = true;
      package = pkgs.mdformat.withPlugins (p:
        with p; [
          mdformat-gfm
          mdformat-gfm-alerts
          mdformat-tables
          mdformat-simple-breaks
        ]);
    };
    nixf-diagnose.enable = true;
    rustfmt.enable = true;
    shellcheck.enable = true;
    shfmt.enable = true;
    stylua.enable = true;
  };
}
