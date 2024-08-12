{
description = "Halogen Purescript";

inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; 
  ps-tools.follows = "purs-nix/ps-tools"; 
  purs-nix.url = "github:purs-nix/purs-nix/ps-0.15"; 
  utils.url = "github:numtide/flake-utils"; 
  purescript-overlay = {
    url = "github:cardanonix/purescript-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};

outputs = { nixpkgs, utils, ... }@inputs:
  utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
    (system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.extend (self: super: {
          overlays = [ inputs.purescript-overlay.overlays.default ];
        });
        ps-tools = inputs.ps-tools.legacyPackages.${system};
        purs-nix = inputs.purs-nix { inherit system; };
        ps =
          purs-nix.purs
            {
              dependencies =
                with purs-nix.ps-pkgs;
                [
                  console
                  debug
                  effect
                  # foreign
                  halogen
                  prelude
                  # maybe
                  # aff
                  # run
                  # strings
                  # parsing
                  affjax-web
                  # arrays
                  # web-events
                  # web-html
                  # web-dom
                  # tuples
                  # integers
                  argonaut
                  argonaut-core
                  argonaut-codecs
                  # ordered-collections
                  # halogen-vdom
                  # string-parsers
                  # css
                  halogen-css
                  # ordered-set
                ];

              dir = ./.;
            };
        ps-command = ps.command { };
        purs-watch = pkgs.writeShellApplication {
          name = "purs-watch";
          runtimeInputs = with pkgs; [ entr ps-command ];
          text = "find src | entr -s 'echo building && purs-nix compile'";
        };
        vite = pkgs.writeShellApplication {
          name = "vite";
          runtimeInputs = with pkgs; [ nodejs ];
          text = "npx vite --open";
        };
        dev = pkgs.writeShellApplication {
          name = "dev";
          runtimeInputs = with pkgs; [ concurrently ];
          text = "concurrently purs-watch vite";
        };
      in
      {
        packages.default = ps.modules.Main.bundle { };

        # checks.default = checks;

        devShells.default =
          pkgs.mkShell
            {
              packages =
                with pkgs;
                [
                  ps-tools.for-0_15.purescript-language-server
                  ps-command
                  purs-nix.purescript
                  purs-watch
                  vite
                  dev
                ];
            };
      }
    );
}
