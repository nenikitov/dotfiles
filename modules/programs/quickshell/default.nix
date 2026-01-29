{libModule, ...}:
libModule.mkEnableModule {
  path = ["programs" "quickshell"];
  description = "Quickshell UI framwork";
  config = {
    configGlobal,
    configNamespace,
    ...
  }: {
    programs.quickshell = {
      enable = true;
    };
    xdg.configFile.quickshell.source =
      configGlobal.lib.file.mkOutOfStoreSymlink
      "${configNamespace.settings.dotfilesPath}/modules/programs/quickshell/config";
  };
}
