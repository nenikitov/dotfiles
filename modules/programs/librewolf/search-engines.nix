{
  lib,
  libModule,
  ...
}:
libModule.mkEnableSubmodule rec {
  pathParent = ["programs" "librewolf"];
  path = pathParent ++ ["searchEngines"];
  options = {
    linux = {
      enable = lib.mkEnableOption "Linux related search engines";
      nixosChannel = lib.mkOption {
        description = "Channel that NixOS system follows";
        default = "unstable";
        example = "25.05";
        type = lib.types.str;
      };
      homeChannel = lib.mkOption {
        description = "Channel that Home Manager follows";
        default = "unstable";
        example = "25.05";
        type = lib.types.str;
      };
    };
    programming.enable = lib.mkEnableOption "programming related search engines";
    game.enable = lib.mkEnableOption "game related search engines";
  };
  config = {configModule, ...}: let
    common = {
      startpage = {
        name = "Startpage";
        iconMapObj."64" = "https://www.startpage.com/favicon.ico";
        definedAliases = ["@s" "@startpage"];
        urls = [
          {
            template = "https://www.startpage.com/sp/search";
            params = [
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
          {
            type = "application/x-suggestions+json";
            template = "https://www.startpage.com/osuggestions";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      brave = {
        name = "Brave Search";
        iconMapObj."32" = "https://cdn.search.brave.com/serp/v3/_app/immutable/assets/favicon-32x32.B2iBzfXZ.png";
        definedAliases = ["@b" "@brave"];
        urls = [
          {
            template = "https://search.brave.com/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
          {
            type = "application/x-suggestions+json";
            template = "https://search.brave.com/api/suggest";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      youtube = {
        name = "YouTube";
        iconMapObj."16" = "https://youtube.com/favicon.ico";
        definedAliases = ["@y" "@youtube"];
        urls = [
          {
            template = "https://www.youtube.com/results";
            params = [
              {
                name = "search_query";
                value = "{searchTerms}";
              }
            ];
          }
          {
            type = "application/x-suggestions+json";
            template = "https://www.google.com/complete/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
              {
                name = "ds";
                value = "yt";
              }
              {
                name = "output";
                value = "firefox";
              }
            ];
          }
        ];
      };
      google.metaData.alias = "@g";
      ddg.metaData.alias = "@d";
      wikipedia.metaData.alias = "@w";
      bing.metaData.hidden = true;
    };
    linux = {
      noogle = {
        name = "Noogle";
        iconMapObj."16" = "https://noogle.dev/favicon.png";
        definedAliases = ["@nl" "@noogle"];
        urls = [
          {
            template = "https://noogle.dev/q";
            params = [
              {
                name = "term";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      nix-pkgs = {
        name = "NixOS Packages";
        iconMapObj."16" = "https://search.nixos.org/favicon.png";
        definedAliases = ["@np" "@nix-pkgs"];
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "query";
                value = "{searchTerms}";
              }
              {
                name = "channel";
                value = configModule.linux.nixosChannel;
              }
            ];
          }
        ];
      };
      nix-wiki = {
        name = "NixOS Wiki";
        iconMapObj."16" = "https://nixos.wiki/favicon.png";
        definedAliases = ["@nw" "@nix-wiki"];
        urls = [
          {
            template = "https://nixos.wiki/index.php";
            params = [
              {
                name = "search";
                value = "{searchTerms}";
              }
            ];
          }
          {
            type = "application/x-suggestions+json";
            template = "https://nixos.wiki/api.php";
            params = [
              {
                name = "search";
                value = "{searchTerms}";
              }
              {
                name = "action";
                value = "opensearch";
              }
            ];
          }
        ];
      };
      nix-options = {
        name = "NixOS Options";
        iconMapObj."16" = "https://search.nixos.org/favicon.png";
        definedAliases = ["@no" "@nix-options"];
        urls = [
          {
            template = "https://search.nixos.org/options";
            params = [
              {
                name = "query";
                value = "{searchTerms}";
              }
              {
                name = "channel";
                value = configModule.linux.nixosChannel;
              }
            ];
          }
        ];
      };
      home-pkgs = {
        name = "Home Packages";
        iconMapObj."16" = "https://search.nixos.org/favicon.png";
        definedAliases = ["@np" "@nix-pkgs"];
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "query";
                value = "{searchTerms}";
              }
              {
                name = "channel";
                value = configModule.linux.homeChannel;
              }
            ];
          }
        ];
      };
      home-options = {
        name = "Home Options";
        iconMapObj."16" = "https://search.nixos.org/favicon.png";
        definedAliases = ["@ho" "@home-options"];
        urls = [
          {
            template = "https://home-manager-options.extranix.com";
            params = [
              {
                name = "query";
                value = "{searchTerms}";
              }
              {
                name = "release";
                value =
                  if configModule.linux.homeChannel == "unstable"
                  then "master"
                  else configModule.linux.homeChannel;
              }
            ];
          }
        ];
      };
      arch-wiki = {
        name = "Arch Wiki";
        iconMapObj."16" = "https://wiki.archlinux.org/favicon.ico";
        definedAliases = ["@aw" "@arch-wiki"];
        urls = [
          {
            template = "https://wiki.archlinux.org";
            params = [
              {
                name = "search";
                value = "{searchTerms}";
              }
            ];
          }
          {
            type = "application/x-suggestions+json";
            template = "https://wiki.archlinux.org/api.php";
            params = [
              {
                name = "search";
                value = "{searchTerms}";
              }
              {
                name = "action";
                value = "opensearch";
              }
            ];
          }
        ];
      };
      arch-pkgs = {
        name = "Arch Packages";
        iconMapObj."16" = "https://archlinux.org/favicon.ico";
        definedAliases = ["@ap" "@arch-pkgs"];
        urls = [
          {
            template = "https://archlinux.org/packages";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
    };
    programming = {
      github = {
        name = "GitHub";
        iconMapObj."32" = "https://github.com/favicon.ico";
        definedAliases = ["@gh" "@git-hub"];
        urls = [
          {
            template = "https://github.com/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      grep = {
        name = "grep.app";
        iconMapObj."32" = "https://grep.app/icon.png";
        definedAliases = ["@gr" "@grep"];
        urls = [
          {
            template = "https://grep.app/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      nerd-fonts = {
        name = "Nerd Fonts";
        iconMapObj."16" = "https://www.nerdfonts.com/assets/img/favicon.ico";
        definedAliases = ["@nf" "@nerd-fonts"];
        urls = [
          {
            template = "https://www.nerdfonts.com/cheat-sheet";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
    };
    game = {
      pcgamingwiki = {
        name = "PCGamingWiki";
        iconMapObj."64" = "https://static.pcgamingwiki.com/favicons/pcgamingwiki.png";
        definedAliases = ["@pw" "@pcgamingwiki"];
        urls = [
          {
            template = "https://www.pcgamingwiki.com/w/index.php";
            params = [
              {
                name = "search";
                value = "{searchTerms}";
              }
            ];
          }
          {
            type = "application/x-suggestions+json";
            template = "https://www.pcgamingwiki.com/w/api.php";
            params = [
              {
                name = "search";
                value = "{searchTerms}";
              }
              {
                name = "action";
                value = "opensearch";
              }
            ];
          }
        ];
      };
      protondb = {
        name = "ProtonDB";
        iconMapObj."48" = "https://www.protondb.com/favicon.ico";
        definedAliases = ["@pd" "@protondb"];
        urls = [
          {
            template = "https://www.protondb.com/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      steamdb = {
        name = "SteamDB";
        iconMapObj."32" = "https://steamdb.info/favicon.ico";
        definedAliases = ["@sd" "@steamdb"];
        urls = [
          {
            template = "https://steamdb.info/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
              {
                name = "a";
                value = "all";
              }
            ];
          }
        ];
      };
    };
  in {
    programs.librewolf.profiles.default.search.engines =
      common
      // (
        if configModule.linux.enable
        then linux
        else {}
      )
      // (
        if configModule.programming.enable
        then programming
        else {}
      )
      // (
        if configModule.game.enable
        then game
        else {}
      );
  };
}
