{self, ...}: {
  flake = {
    nixosModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "num lock at startup in TTY sessions";
      config = {pkgs, ...}: {
        # Early system boot - for disk decryption and TTY
        # [Inspiration](https://discourse.nixos.org/t/how-to-enable-num-lock-for-the-disk-decryption-passphrase/40625/7)
        boot.initrd.systemd = {
          storePaths = [
            "${pkgs.kbd}/bin/setleds"
          ];
          services.numlock-on = {
            description = "Enable num lock at startup";
            wantedBy = ["initrd.target"];
            before = ["initrd-root-device.target"];
            unitConfig = {DefaultDependencies = false;};
            script =
              #sh
              ''
                for tty in /dev/tty[1-9]*; do
                  ${pkgs.kbd}/bin/setleds -D +num < "$tty"
                done
              '';
          };
        };

        # Display managers - some like to overwrite it
        services.displayManager.ly.settings.numlock = true;
      };
    };
  };
}
