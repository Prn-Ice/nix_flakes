{
  description = "Flutter Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            android_sdk.accept_license = true;
            allowUnfree = true;
          };
        };
      in
      {
        devShell =
          with pkgs; mkShell
            {
              buildInputs = [
                flutter
                jdk
              ] ++ (if stdenv.isDarwin then [
                cocoapods
              ] else [ ]);
            } // (if !stdenv.isDarwin then {
            CHROME_EXECUTABLE = "google-chrome-stable";
          } else { });
      });
}
