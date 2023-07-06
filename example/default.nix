let
  stoicheia = import ../default.nix { pkgs = import <nixpkgs> { }; };
in
stoicheia.mkProject ({ config, pkgs, lib, ... }: {
  imports = [
    ./modules/build # nix-build -A build.out
    ./modules/shell # nix-shell -A shell.out
  ];

  config = {
    name = "nix-good-practices";
    version = lib.versions.pad 3 (builtins.readFile ./VERSION);

    packages = {
      ruby = pkgs.ruby_3_0;
      gnumake = pkgs.gnumake;
    };

    helpers = {
      addTwo = x: x + 2;
    };

    shell.enabled = true;
    shell.additionalTools = with config.packages; [
      gnumake
    ];

    build.enabled = true;
  };
})
