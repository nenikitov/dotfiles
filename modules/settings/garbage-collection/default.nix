{libModule, ...}:
libModule.mkEnableModule {
  path = ["settings" "garbageCollection"];
  description = "automatic garbage collection";
  config = {
    nix.gc = {
      automatic = true;
      dates = "daily";

      generationTrimmer = {
        enable = true;
        keepAtLeast = 10;
        keepAtMost = 100;
        olderThan = "1 month";
      };
    };
  };
}
