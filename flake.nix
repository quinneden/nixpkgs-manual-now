{
  description = "Nixpkgs Manual, Now!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;

      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];

      forEachSystem = f: lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));
    in
    {
      apps = forEachSystem (pkgs: {
        serve-nixpkgs-manual = {
          type = "app";
          program = lib.getExe (
            pkgs.writeShellApplication {
              name = "serve-nixpkgs-manual";
              runtimeInputs = [ pkgs.nodePackages.http-server ];

              text = ''
                http-server -op 8040 \
                  ${pkgs.nixpkgs-manual}/share/doc/nixpkgs
              '';
            }
          );
        };
      });
    };
}
