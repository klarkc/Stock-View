{
  description = "Stock View";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    easy-purescript-nix.url = "github:justinwoo/easy-purescript-nix";
    purescript-overlay = {
      url = "github:cardanonix/purescript-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      supportedSystems = ["x86_64-linux"
                          "aarch64-linux"
                          "x86_64-darwin" 
                          "aarch64-darwin"
                         ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = [ inputs.purescript-overlay.overlays.default ];
      });
    in {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          vite = pkgs.writeShellApplication {
            name = "vite";
            runtimeInputs = with pkgs; [ nodejs ];
            text = "npx vite --open";
          };
        in {
          default = pkgs.mkShell {
            name = "stockView";
            buildInputs = with pkgs; [
              purs
              spago
              purs-tidy-bin.purs-tidy-0_10_0
              purs-backend-es
              vite
              nodejs
            ];
          };
        });
    };
}

#   outputs = { nixpkgs, flake-utils, easy-purescript-nix, ... }:
#     flake-utils.lib.eachDefaultSystem (system:
#       let
#         pkgs = nixpkgs.legacyPackages.${system};
#         easy-ps = easy-purescript-nix.packages.${system};
#       in
#       {
#         devShells = {
#           default = pkgs.mkShell {
#             name = "purescript-custom-shell";
#             buildInputs = [
#               easy-ps.purs-0_15_14
#               easy-ps.spago
#               easy-ps.purescript-language-server
#               easy-ps.purs-tidy
#               pkgs.nodejs-18_x
#               pkgs.esbuild
#             ];
#             shellHook = ''
#               source <(spago --bash-completion-script `which spago`)
#               source <(node --completion-bash)
#               '';
#           };
#        };
#      }
#   );
# }

#New Projects 
# command I ran for latest spago init:
# spago init -C



# inputs = {
#   nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; 
#   ps-tools.follows = "purs-nix/ps-tools"; 
#   purs-nix.url = "github:purs-nix/purs-nix/ps-0.15"; 
#   utils.url = "github:numtide/flake-utils"; 

# };

# outputs = { nixpkgs, utils, ... }@inputs:
#   utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
#     (system:
#       let
#         pkgs = nixpkgs.legacyPackages.${system}.extend (self: super: {
#           overlays = [ inputs.purescript-overlay.overlays.default ];
#         });
#         ps-tools = inputs.ps-tools.legacyPackages.${system};
#         purs-nix = inputs.purs-nix { inherit system; };
#         ps =
#           purs-nix.purs
#             {
#               dependencies =
#                 with purs-nix.ps-pkgs;
#                 [
                  # aff
                  # affjax-web
                  # argonaut
                  # argonaut-codecs
                  # argonaut-core
                  # arrays
                  # console
                  # css
                  # debug
                  # effect
                  # foreign
                  # halogen
                  # halogen-css
                  # halogen-vdom
                  # integers
                  # maybe
                  # ordered-collections
                  # ordered-set
                  # parsing
                  # prelude
                  # run
                  # string-parsers
                  # strings
                  # tuples
                  # web-dom
                  # web-events
                  # web-html
#                 ];

#               dir = ./.;
#             };
#         ps-command = ps.command { };
#         purs-watch = pkgs.writeShellApplication {
#           name = "purs-watch";
#           runtimeInputs = with pkgs; [ entr ps-command ];
#           text = "find src | entr -s 'echo building && purs-nix compile'";
#         };
#         vite = pkgs.writeShellApplication {
#           name = "vite";
#           runtimeInputs = with pkgs; [ nodejs ];
#           text = "npx vite --open";
#         };
#         dev = pkgs.writeShellApplication {
#           name = "dev";
#           runtimeInputs = with pkgs; [ concurrently ];
#           text = "concurrently purs-watch vite";
#         };
#       in
#       {
#         packages.default = ps.modules.Main.bundle { };

#         # checks.default = checks;

#         devShells.default =
#           pkgs.mkShell
#             {
#               packages =
#                 with pkgs;
#                 [
#                   ps-tools.for-0_15.purescript-language-server
#                   ps-command
#                   purs-nix.purescript
#                   purs-watch
#                   vite
#                   dev
#                 ];
#             };
#       }
#     );
# }
