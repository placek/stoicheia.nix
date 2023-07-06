{ pkgs ? import <nixpkgs> { }
, ...
}:
let
  stoicheiaModule = { config, lib, ... }: {
    options = with lib; {
      name = mkOption {
        type = types.str;
        example = "my-project";
        description = ''
          The code name of the project.
        '';
      };

      version = mkOption {
        type = types.separatedString ".";
        example = "1.2.0.4-rc2";
        description = ''
          The version of the project.
        '';
      };

      helpers = mkOption {
        type = types.attrsOf (types.functionTo types.anything);
        default = { };
        description = ''
          The helper functions.
        '';
      };

      packages = mkOption {
        type = types.attrsOf types.package;
        default = { };
        description = ''
          The dependencies of the project.
          This is the place to define packages widely used throughout whole project configuration.
        '';
      };

      targets = mkOption {
        type = types.attrsOf types.package;
        default = { };
        description = ''
          The output build targetss of the project.
          This is the place to define derivations that can be used by CLI.
        '';
      };
    };
  };
in
{
  mkProject = configuration: pkgs.lib.evalModules {
    modules = [ stoicheiaModule configuration ];
    specialArgs = { inherit pkgs; inherit (pkgs) lib; };
  };
}
