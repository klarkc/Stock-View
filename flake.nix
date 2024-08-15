{
  description = "Stock View";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    purescript-overlay = {
      url = "github:cardanonix/purescript-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    purescript-overlay,
    ...
  }: let
    name = "stockView";

    supportedSystems = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-darwin" 
      "x86_64-linux"
    ];

    forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
  in {
    devShell = forAllSystems (system: let
      overlays = [purescript-overlay.overlays.default];
      pkgs = import nixpkgs {inherit system overlays;};
      vite = pkgs.writeShellApplication {
        name = "vite";
        runtimeInputs = with pkgs; [ nodejs_20 ];
        text = "npx vite --open";
      };
    in
      pkgs.mkShell {
        inherit name;
        buildInputs =
          [
            pkgs.esbuild
            pkgs.nodejs_20
            pkgs.nixpkgs-fmt
            pkgs.purs
            pkgs.purs-tidy
            pkgs.purs-backend-es
            pkgs.purescript-language-server
            pkgs.spago-unstable
            pkgs.vite
          ]
          ++ (pkgs.lib.optionals (system == "aarch64-darwin")
            (with pkgs.darwin.apple_sdk.frameworks; [
              Cocoa
              CoreServices
            ]));
      });
  };
}
