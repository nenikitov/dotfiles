{
  libModule,
  pkgs,
  ...
}:
libModule.mkEnableModule {
  path = ["programs" "neovim"];
  description = "NeoVim text editor";
  config = {
    configGlobal,
    configNamespace,
    ...
  }: {
    programs = {
      neovim = {
        enable = true;
        defaultEditor = true;
        withRuby = false;
        withPython3 = true;
        extraPackages = with pkgs; [
          gcc
          libcxx
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

    # xdg.configFile.nvim.source =
    #   configGlobal.lib.file.mkOutOfStoreSymlink
    #   "${configNamespace.settings.dotfilesPath}/modules/programs/neovim/config";
  };
}
