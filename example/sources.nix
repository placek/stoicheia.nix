let
  sourcesFile = ./sources.json;
  nixpkgs =
    if builtins.pathExists sourcesFile
    then builtins.fetchGit (builtins.fromJSON (builtins.readFile sourcesFile))
    else <nixpkgs>;
in
{ inherit nixpkgs; }
