{
  description = "Python 3.12 development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
          };
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            python312
            python312Packages.pip
            python312Packages.virtualenv
            stdenv.cc.cc.lib  # Adds libstdc++
            zlib
            glib
            pkg-config
            cmake
            ninja
            cudaPackages.cuda_cudart
            cudaPackages.cuda_cupti
            cudaPackages.cudatoolkit
            cudaPackages.cudnn
            cudaPackages.nccl
            linuxPackages.nvidia_x11_beta
          ];

          shellHook = ''
            # Create virtual environment if it doesn't exist
            if [ ! -d "venv" ]; then
              python -m venv venv
            fi
            source venv/bin/activate
            
            # Make sure pip is up to date
            python -m pip install --upgrade pip

            # Set up CUDA environment
            export CUDA_PATH=${pkgs.cudaPackages.cuda_cudart}
            export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:${pkgs.cudaPackages.cuda_cudart}/lib:${pkgs.cudaPackages.cudatoolkit}/lib:${pkgs.cudaPackages.cudnn}/lib:${pkgs.linuxPackages.nvidia_x11_beta}/lib:$LD_LIBRARY_PATH
            export EXTRA_LDFLAGS="-L/lib -L${pkgs.cudaPackages.cuda_cudart}/lib"
            export EXTRA_CCFLAGS="-I/usr/include"
          '';
        };
      });
}
