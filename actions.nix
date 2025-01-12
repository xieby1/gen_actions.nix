let
  pkgs = import <nixpkgs> {};
  mypkgs = import ./mypkgs.nix;
  ymls = pkgs.lib.mapAttrsToList (name: value:
    (pkgs.formats.yaml {}).generate "${name}.yml" {
      inherit name;
      on = {
        push = {
          branches = ["actions"];
      };};
      jobs = {
        "${name}" = {
          runs-on = "ubuntu-latest";
          steps = [
            { uses = "actions/checkout@v4"; }
            { uses = "cachix/install-nix-action@v27";
              "with" = {nix_path = "nixpkgs=channel:nixos-24.11";}; }
            { run = "nix-build ./mypkgs.nix -A ${name}"; }
      ];};};
    }
  ) mypkgs;
in pkgs.runCommand "workflows" {} ''
  mkdir -p $out
  for yml in ${toString ymls}; do
    ln -s $yml $out/''${yml#*-}
  done
''
