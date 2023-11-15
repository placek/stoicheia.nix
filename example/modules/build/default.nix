# documentation: https://nixos.org/manual/nixos/unstable/index.html#sec-writing-modules
{ pkgs, config, lib, ... }:
{
  options.build = with lib; {
    enabled = mkEnableOption "build";
  };

  config.targets.build = lib.mkIf config.build.enabled (pkgs.stdenv.mkDerivation {
    name = config.name;
    version = config.version;
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out
      ${config.packages.ruby}/bin/ruby -e "puts '$name $version'" > $out/test
      ${config.packages.ruby}/bin/ruby -e "puts '${builtins.toString (config.helpers.addTwo 7)}'" >> $out/test
      ${config.packages.ruby}/bin/ruby -v >> $out/test
    '';
  });
}
