{
  description = "Command Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        create-netrc = import ./apps/create-netrc.nix { pkgs = pkgs; };
        install-localdev = import ./apps/install-localdev.nix { pkgs = pkgs; };
        npm-login = import ./apps/npm-login.nix { pkgs = pkgs; };
        pull-repos = import ./apps/pull-repos.nix { pkgs = pkgs; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs_20
            yarn
            pnpm
            go
            create-netrc
            install-localdev
            npm-login
            pull-repos
          ];
          shellHook = ''
            export PATH="$HOME/go/bin:$PATH"
          '';
        };
      }
    );
}
