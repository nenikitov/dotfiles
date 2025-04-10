{
  config,
  lib,
  ...
}: let
  cfg = config.ne.programs.imv;
in {
  options.ne.programs.imv = {
    enable = lib.mkEnableOption "imv image viewer";
  };
  config = lib.mkIf cfg.enable {
    programs.imv = {
      enable = true;
    };
    # HACK(nenikitov): Add all options under `programs.imv` instead of writing to the file if this gets fixed
    # Because it auto-orders sections and `binds` is before `options.suppress_default_binds`
    # So custom binds get cleared
    # https://github.com/nix-community/home-manager/pull/3481#issuecomment-1584725951
    xdg.configFile."imv/config".text =
      # dosini
      ''
        [options]
        background=checks
        overlay=true
        overlay_font=monospace:11
        suppress_default_binds=true

        [binds]
        q=quit
        <Shift+H>=pan 20 0
        <Shift+J>=pan 0 -20
        <Shift+K>=pan 0 20
        <Shift+L>=pan -20 0
        l=next
        h=prev
        g=goto 1
        <Shift+G>=goto -1
        k=zoom 2
        j=zoom -2
        r=rotate by 90
        <Shift+R>=rotate by -90
        f=flip horizontal
        <Shift+F>=flip vertical
        o=overlay
        s=upscaling next
        b1=background checks
        b2=background #000000
        b3=background #FFFFFF
      '';
  };
}
