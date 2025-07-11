{
  libModule,
  options,
  ...
}:
libModule.mkEnableModule {
  path = ["programs" "git"];
  description = "git version control tool";
  options = {
    userName = options.programs.git.userName // {default = "nenikitov";};
    # TODO: Figure out how to safely pass email
    userEmail = options.programs.git.userEmail;
  };
  config = {configModule, ...}: {
    programs.git = {
      enable = true;

      inherit (configModule) userName userEmail;

      # TODO: look into delta differ

      extraConfig = {
        # Set default branch to `main`
        init.defaultBranch = "main";

        # Do not guess `user.name` and `user.email` if not set
        user.useConfigOnly = true;

        # Correct mistyped commands after 0.5 second
        help.autocorrect = 5;

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
