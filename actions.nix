let
  pkgs = import <nixpkgs> {};
  mypkgs = import ./mypkgs.nix;
in builtins.mapAttrs (name: value:
  (pkgs.formats.yaml {}).generate "${name}.yml" {
    inherit name;
    on = {
      push = {
        branches = ["main"];
    };};

    jobs = {
      "${name}" = {
        runs-on = "ubuntu-latest";
        steps = [
          { uses = "actions/checkout@v4"; }
          { uses = "cachix/install-nix-action@v23";
            "with" = {nix_path = "nixpkgs=channel:nixos-24.05";}; }
          { run = "nix-build ./mypkgs.nix -A ${name}"; }
    ];};};
  }
) mypkgs
