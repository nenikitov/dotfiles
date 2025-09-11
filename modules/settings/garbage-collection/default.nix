{
  libModule,
  pkgs,
  ...
}:
libModule.mkEnableModule {
  path = ["settings" "garbageCollection"];
  description = "automatic garbage collection";
  config = {
    nix = {
      gc = {
        automatic = true;
        dates = "daily";
      };
    };

    systemd.user.services = {
      # Make `gc` depend on my generation selector
      nix-gc.Unit.Wants = ["nix-gc-gen.service"];

      nix-gc-gen = {
        Unit.Description = "NixOS generation filter for garbage collection";
        Service = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "nix-gc-gen" ''
            exec "${pkgs.nix-generation-trimmer}/bin/nix-generation-trimmer" \
              user channel home-manager                                      \
              --older-than 7d                                                \
              --min 10                                                       \
              --max 50                                                       \
              --dry-run
          '';
        };
      };
    };
  };
}
