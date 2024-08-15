{
  description = "Stock View";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    purescm.url = "github:/purescm/purescm";
    purescript-overlay = {
      url = "github:cardanonix/purescript-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs = { self, nixpkgs, purescm, purescript-overlay, ... }: let
    name = "stockView";

    supportedSystems = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];

    forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
  in {
    devShell = forAllSystems (system: let
      overlays = [
        purescript-overlay.overlays.default
        purescm.overlays.purescript
      ];
      pkgs = import nixpkgs { inherit system overlays; };
      vite = pkgs.writeShellApplication {
        name = "vite";
        runtimeInputs = with pkgs; [ nodejs_20 ];
        text = "npx vite --open";
      };
      chez = pkgs.chez.overrideAttrs (final: prev: {
        postFixup = if pkgs.stdenv.isDarwin then ''
          install_name_tool -add_rpath ${pkgs.pcre2.out}/lib $out/bin/scheme
        '' else ''
          patchelf $out/bin/scheme --add-rpath ${pkgs.pcre2.out}/lib
        '';
      });
      # pursBackendScm = pkgs.purs-backend-scm;
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

            # Chez Scheme compiler and PureScript backend
            pkgs.purs-bin.purs-0_15_10
            pkgs.pkg-config
            pkgs.nodejs-slim
            pkgs.chez
            pkgs.purescm
          ]
          ++ (pkgs.lib.optionals (system == "aarch64-darwin")
            (with pkgs.darwin.apple_sdk.frameworks; [
              Cocoa
              CoreServices
            ]));
      });
  };
}
