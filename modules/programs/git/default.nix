{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "git version control tool";
      options = {lib, ...}: {
        user = {
          name = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = "nenikitov";
            description = "User name to author commits with.";
          };
          # TODO: Figure out how to safely store email without hard-coding it in a public repository
          email = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "User email to author commits with.";
          };
        };
      };
      config = {configModule, ...}: {
        programs.git = {
          enable = true;

          settings = {
            # Author
            user = {
              ${
                if configModule.user.name != null
                then "name"
                else null
              } =
                configModule.user.name;

              ${
                if configModule.user.email != null
                then "email"
                else null
              } =
                configModule.user.email;

              # Do not guess author if not set
              useConfigOnly = true;
            };

            # Use `main` instead of `master`
            init.defaultBranch = "main";

            status = {
              # Less verbose `git status`
              short = true;
              branch = true;
              showStash = true;
              # Do not group untracked files into directories
              showUntrackedFiles = "all";
            };

            diff = {
              # Detect file copies too
              renames = "copies";
              # Works better with moved hunks
              algorithm = "histogram";
              # TODO: Look into `delta` differ
            };

            # Add diffs when editing a commit in the text editor
            commit.verbose = true;

            # Also add previous version in merge conflict markers
            merge.conflictStyle = "zdiff3";

            # Sorts and formats
            branch.sort = "-committerdate";
            tag.sort = "taggerdate";
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
    };
  };
}
