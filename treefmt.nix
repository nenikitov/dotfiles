{inputs, ...}: {
  imports = [inputs.treefmt.flakeModule];
  perSystem = {
    treefmt = {
      programs.alejandra.enable = true;
    };
  };
}
