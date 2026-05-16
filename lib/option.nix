{inputs, ...}: {
  flake.lib.option = let
    inherit (inputs.nixpkgs) lib;
  in {
    mkBoolOption = {
      description ? null,
      descriptionFull ? null,
      ...
    } @ args:
      args
      |> lib.flip builtins.removeAttrs ["description" "descriptionFull"]
      |> (a:
        {
          default = false;
          example = true;
          type = lib.types.bool;
          description =
            if description != null && descriptionFull != null
            then throw "Cannot have both `description` and `descriptionFull`"
            else if descriptionFull != null
            then descriptionFull
            else if description != null
            then "Whether to ${description}."
            else null;
        }
        // a)
      |> lib.mkOption;

    mkChannelOption = description:
      lib.mkOption {
        inherit description;
        example = "25.11";
        type = lib.types.either (lib.types.enum ["unstable"]) (lib.types.str);
        default = "unstable";
      };
  };
}
