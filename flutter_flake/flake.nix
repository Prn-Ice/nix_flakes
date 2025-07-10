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
      # Documentation: https://nixos.org/manual/nixpkgs/unstable/#android
      buildToolsVersion = "34.0.0";
      androidComposition = pkgs.androidenv.composeAndroidPackages {
        buildToolsVersions = [buildToolsVersion "28.0.3"];
        platformVersions = ["35" "34" "33" "31"];
        # abiVersions = ["armeabi-v7a" "arm64-v8a"];
        # systemImageTypes = ["default"];
        # abiVersions = ["x86" "x86_64" "armeabi-v7a" "arm64-v8a"];
        # includeSystemImages = true;
        includeEmulator = true;
        systemImageTypes = ["google_apis_playstore"];

        # The `licenseAccepted = true;` seems to only work when androidenv.buildApp
        # is used. Since Flutter doesn't use that it doesn't work.
        # Therefore we can manually accept the different licenses here.
        # Copied from: https://github.com/SharezoneApp/sharezone-app/blob/0bc1bfc2776305683e8d1c6e5f5d7c77dbef97ed/devenv.nix#L18
        # Copied from: https://github.com/NixOS/nixpkgs/issues/267263#issuecomment-1833769682
        extraLicenses = [
          "android-googletv-license"
          "android-sdk-arm-dbt-license"
          "android-sdk-license"
          "android-sdk-preview-license"
          "google-gdk-license"
          "intel-android-extra-license"
          "intel-android-sysimage-license"
          "mips-android-sysimage-license"
        ];
      };
      androidSdk = androidComposition.androidsdk;
    in {
      default = pkgs.mkShell {
        ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
        # override the aapt2 that gradle uses with the nix-shipped version
        GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/${buildToolsVersion}/aapt2";

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
              ruby
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
              vulkan-loader
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
