{
  description = "Development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };

          inputs = [
            pkgs.ripgrep
            pkgs.git-up
            pkgs.nodejs-18_x
          ];

          shellHooks = ''
            mkdir -p .nix-node
            export NODE_PATH=$PWD/.nix-node
            export NPM_CONFIG_PREFIX=$PWD/.nix-node
            export PATH=$NODE_PATH/bin:$PATH

            npm install --global editorconfig-checker

            echo "#!/bin/bash" > .nix-node/lint
            echo "ec" >> .nix-node/lint
            chmod +x .nix-node/lint
          '';
        in
        {
          devShells = {
            default = pkgs.mkShellNoCC {
              name = "tomtomsen dotfiles";

              buildInputs = inputs;
              shellHook = shellHooks;
            };
          };
        }
      );
}
