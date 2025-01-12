let
  pkgs = import <nixpkgs> {};
in {
  inherit (pkgs) hello gnumake nyancat ripgrep tldr file;
}
