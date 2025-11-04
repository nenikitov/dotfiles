{
  lib,
  libModule,
  ...
}:
libModule.mkEnableModule {
  path = ["programs" "git"];
  description = "git version control tool";
  options = {
    user = {
      name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "nenikitov";
        description = "User name to use.";
      };
      ## TODO: Figure out how to safely pass email
      email = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "User email to use.";
      };
    };
  };
  config = {configModule, ...}: {
    programs.git = {
      enable = true;

      settings = {
        user = {
          inherit (configModule.user) name;
          ${
            if configModule.user.email != null
            then "email"
            else null
          } =
            configModule.user.email;
        };
        # TODO: look into delta differ

        # Set default branch to `main`
        init.defaultBranch = "main";

        # Do not guess `user.name` and `user.email` if not set
        user.useConfigOnly = true;

        # Correct mistyped commands after 1 second
        help.autocorrect = 10;

        status = {
          # Make status less verbose
          short = true;
          # Show branch name when using short format
          branch = true;
          # Show number of stashes
          showStash = true;
          # Do not group untracked files into directories
          showUntrackedFiles = "all";
        };

        diff = {
          # Dect file copies as renames too
          renames = "copies";
          # Works better with moved chunks of code
          algorithm = "histogram";
        };

        # Add diffs when editing a commit message in the editor
        commit.verbose = true;

        # Add a version before merge conflict in between conflict markers
        merge.conflictstyle = "zdiff3";

        # Sort branches by recency
        branch.sort = "-committerdate";

        # Sort tags by recency
        tag.sort = "taggerdate";

        # ISO date my beloved
        log.date = "iso";

        # URL shortcuts
        url = {
          "https://github.com/nenikitov/".insteadOf = "nenikitov:";

          "https://github.com/".insteadOf = "gh:";
          "https://gitlab.com/".insteadOf = "gl:";
          "https://bitbucket.com/".insteadOf = "bb:";
        };
      };
    };
  };
}
