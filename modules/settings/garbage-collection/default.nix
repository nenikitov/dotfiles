{
  libModule,
  pkgs,
  ...
}:
libModule.mkEnableModule {
  path = ["settings" "garbageCollection"];
  description = "automatic garbage collection";
  config = {
    nix.gc = {
      automatic = true;
      dates = "daily";
    };

    systemd.user.services = {
      # Make built-in service depend on the generation selector
      nix-gc.Unit.Wants = ["nix-gc-gen.service"];
      # Generation selector for garbage collection
      nix-gc-gen = {
        Unit.Description = "Generation selector for garbage collection";
        Service = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "nix-gc-gen" ''
            exec "${pkgs.nix-generation-trimmer}/bin/nix-generation-trimmer" \
              user channel home-manager                                      \
              --older-than 7d                                                \
              --keep-at-least 10                                             \
              --keep-at-most 100
          '';
        };
      };
    };
  };
}
