{
  description = "Cross-platform development environment for Node.js and Java";
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
            permittedInsecurePackages = [
              "python-2.7.18.8"
            ];
          };
        };

        # System-specific configurations
        isMacOS = system == "aarch64-darwin" || system == "x86_64-darwin";

        # Choose between podman (macOS) and docker (Linux)
        containerEngine = if isMacOS then pkgs.podman else pkgs.docker;

        # Podman compatibility layer for macOS
        podmanDockerCompat =
          if isMacOS then [
            (pkgs.runCommand "${pkgs.podman.pname}-docker-compat-${pkgs.podman.version}"
              {
                outputs = [ "out" "man" ];
                inherit (pkgs.podman) meta;
              }
              ''
                mkdir -p $out/bin
                ln -s ${pkgs.podman}/bin/podman $out/bin/docker

                mkdir -p $man/share/man/man1
                for f in ${pkgs.podman.man}/share/man/man1/*; do
                  basename=$(basename $f | sed s/podman/docker/g)
                  ln -s $f $man/share/man/man1/$basename
                done
              ''
            )
          ] else [ ];

        # System-specific shell hook
        systemSpecificHook =
          if isMacOS then ''
            export DOCKER_HOST="unix://$HOME/.podman/podman-machine-default-api.sock"
          
            # Check if podman machine exists and is running
            if ! podman machine list | grep -q "podman-machine-default"; then
              echo "Creating podman machine..."
              podman machine init || handle_error "Failed to initialize podman machine"
            fi
          
            if ! podman machine list | grep -q "Currently running"; then
              echo "Starting podman machine..."
              podman machine start || handle_error "Failed to start podman machine"
            fi
          '' else ''
            # Linux-specific environment variables for Puppeteer
            export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
            export CHROMIUM_PATH=${pkgs.chromium}/bin/chromium
            export PUPPETEER_EXECUTABLE_PATH=${pkgs.chromium}/bin/chromium
          '';

      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            # Node.js development tools
            nodejs
            yarn

            # Java development
            (if isMacOS then jdk11 else zulu11)

            # Container management
            containerEngine
            docker-compose
            (if isMacOS then lazydocker else null)

            # Linux-specific tools
            (if !isMacOS then chromium else null)
            (if !isMacOS then utillinux else null)

            # Legacy dependencies
            python2

            # Database
            mariadb
          ] ++ podmanDockerCompat;

          shellHook = ''
            # Function to handle errors
            handle_error() {
              echo "Error: $1"
              exit 1
            }

            # Set up environment variables
            export NODE_ENV="development"
            export JAVA_HOME=${if isMacOS then "${pkgs.jdk11}" else "${pkgs.zulu11.home}"}
            
            ${systemSpecificHook}

            echo "Development environment ready!"
            echo "Available commands:"
            echo "  - ${if isMacOS then "podman" else "docker"}: Container management"
            echo "  - docker-compose: Container orchestration"
            ${if isMacOS then ''echo "  - lazydocker: Terminal UI for docker"'' else ""}
            echo "  - yarn: Package management"
          '';

          # Cleanup on exit (macOS only)
          shellExit =
            if isMacOS then ''
              echo "Cleaning up development environment..."
              podman machine stop || echo "Warning: Failed to stop podman machine"
            '' else '''';
        };
      });
}
