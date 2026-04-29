{inputs, ...}: {
  flake.lib.case = let
    inherit (inputs.nixpkgs) lib;
  in rec {
    capitalize = str:
      (str |> builtins.substring 0 1 |> lib.toUpper)
      + (str |> builtins.substring 1 (-1));

    kebabToWords = str:
      str
      # Split in `-`
      |> builtins.split "-"
      # Don't forget to remove empty capture groups
      |> builtins.filter builtins.isString
      # Normalize
      |> builtins.map lib.toLower;

    snakeToWords = str:
      str
      # Split in `-`
      |> builtins.split "_"
      # Don't forget to remove empty capture groups
      |> builtins.filter builtins.isString
      # Normalize
      |> builtins.map lib.toLower;

    pascalToWords = str:
      str
      # Split on
      # - Lower / Upper       (helloWorld -> hello / World)
      # - Upper / Upper Lower (HTTPRequest -> HTTP / Request)
      # - Digit / Letter      (10Hello -> 10 / Hello)
      # - Letter / Digit      (Hello10 -> Hello / 10)
      |> builtins.split ''([a-z])([A-Z])|([A-Z])([A-Z][a-z])|([0-9])([a-zA-Z])|([a-zA-Z])([0-9])''
      # Last regex produces a bunch of null groups, get the captured pair and put `null` in the middle
      |> builtins.map (s:
        if builtins.isList s
        then
          s
          |> builtins.filter (s: s != null)
          |> (s: [(builtins.elemAt s 0) null (builtins.elemAt s 1)])
        else s)
      # Flatten
      |> lib.flatten
      # Split on `null`
      |> builtins.foldl' (acc: elem:
        if elem == null
        then {
          words = acc.words ++ [acc.word];
          word = "";
        }
        else {
          words = acc.words;
          word = acc.word + elem;
        })
      {
        words = [];
        word = "";
      }
      # Add final word
      |> (acc: acc.words ++ [acc.word])
      # Normalize
      |> builtins.filter (w: w != "")
      |> builtins.map lib.toLower;

    camelToWords = pascalToWords;

    wordsToKebab = words: words |> builtins.concatStringSep "-";

    wordsToSnake = words: words |> builtins.concatStringSep "_";

    wordsToPascal = words: words |> builtins.map capitalize |> builtins.concatStringsSep "";

    wordsToCamel = words:
      if words == []
      then ""
      else
        (
          [(builtins.head words)]
          ++ (words |> builtins.tail |> builtins.map capitalize)
        )
        |> builtins.concatStringsSep "";

    convert = {
      from,
      to,
    }: str: let
      fromFns = {
        kebab = kebabToWords;
        snake = snakeToWords;
        pascal = pascalToWords;
        camel = camelToWords;
      };
      toFns = {
        kebab = wordsToKebab;
        snake = wordsToSnake;
        pascal = wordsToPascal;
        camel = wordsToCamel;
      };
    in
      str
      |> fromFns."${from}" or (throw "Unknown from format ${from}")
      |> toFns."${to}" or (throw "Unknown to format ${to}");
  };
}
