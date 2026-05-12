{self, ...}: {
  flake = {
    homeModules = self.lib.mkEnableModule {
      path = __curPos;
      description = "SponsorBlock Librewolf extension.";
      config = {inputs', ...}: {
        ${self.lib.namespace}.programs.librewolf.extensions.extensions = [
          {
            package = inputs'.firefox-addons.packages.sponsorblock;
            settings.sync = {
              categorySelections = [
                {
                  name = "filler";
                  option = 1;
                }
                {
                  name = "hook";
                  option = 1;
                }
                {
                  name = "interaction";
                  option = 1;
                }
                {
                  name = "intro";
                  option = 1;
                }
                {
                  name = "music_offtopic";
                  option = 1;
                }
                {
                  name = "poi_highlight";
                  option = 1;
                }
                {
                  name = "preview";
                  option = 1;
                }
                {
                  name = "selfpromo";
                  option = 1;
                }
                {
                  name = "sponsor";
                  option = 1;
                }
                {
                  name = "chapter";
                  option = 0;
                }
                {
                  name = "exclusive_access";
                  option = 0;
                }
              ];
              showDeArrowInSettings = false;
              showDeArrowPromotion = false;
              hideVideoPlayerControls = true;
            };
          }
        ];
      };
    };
  };
}
