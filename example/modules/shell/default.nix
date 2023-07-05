# documentation: https://nixos.org/manual/nixos/unstable/index.html#sec-writing-modules
{ pkgs, config, lib, ... }:
{
  options.shell = with lib; {
    enabled = mkEnableOption "shell";

    additionalTools = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "The other development tools used during the process of creating a project.";
    };
  };

  config.targets.shell = lib.mkIf config.shell.enabled (pkgs.mkShell {
    packages = [ config.packages.ruby ] ++ config.shell.additionalTools;

    shellHook = ''
      echo ${config.name}-${config.version}
      ruby -v
    '';
  });
}
