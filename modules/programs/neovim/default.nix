{libModule, ...}:
libModule.mkEnableModule {
  path = ["programs" "neovim"];
  description = "NeoVim text editor";
  config = {
    configGlobal,
    configNamespace,
    ...
  }: {
    xdg.configFile.nvim.source =
      configGlobal.lib.file.mkOutOfStoreSymlink
      "${configNamespace.settings.dotfiles_path}/modules/programs/neovim/config";
  };
}
