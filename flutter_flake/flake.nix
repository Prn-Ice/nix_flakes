{
  description = "Flutter Flake";
  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
  }: let
    forEachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
            config = {
              android_sdk.accept_license = true;
              allowUnfree = true;
            };
          };
        });
  in {
    devShells = forEachSystem ({pkgs}: let
      buildToolsVersion = "34.0.0";
      androidComposition = pkgs.androidenv.composeAndroidPackages {
        buildToolsVersions = [buildToolsVersion "28.0.3"];
        platformVersions = ["34" "28"];
        abiVersions = ["armeabi-v7a" "arm64-v8a"];
      };
      androidSdk = androidComposition.androidsdk;
    in {
      default = pkgs.mkShell {
        ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
        buildInputs = with pkgs;
          [
            zulu17
            lcov
          ]
          ++ (
            if pkgs.stdenv.isDarwin
            then [
              cocoapods
            ]
            else [
              flutter
              androidSdk
              gst_all_1.gstreamer
              gst_all_1.gst-plugins-base
              gst_all_1.gst-plugins-good
              gst_all_1.gst-plugins-bad
              gst_all_1.gst-plugins-ugly
              gst_all_1.gst-libav
              pkg-config
              glib
              gtk3
              xorg.libX11
              xorg.libXcomposite
              xorg.libXcursor
              xorg.libXdamage
              xorg.libXext
              xorg.libXfixes
              xorg.libXi
              xorg.libXrandr
              xorg.libXrender
              xorg.libXtst
              xorg.libxcb
              libGL
              libGLU
            ]
          );

        shellHook =
          if !pkgs.stdenv.isDarwin
          then ''
            export CHROME_EXECUTABLE="google-chrome-stable"
            export PATH="$PATH:$HOME/.pub-cache/bin"
          ''
          else ''
            # Use system Xcode on Darwin
            export PATH="$PATH:$HOME/.pub-cache/bin"
            export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
            export SDKROOT="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
          '';
      };
    });
  };
}
