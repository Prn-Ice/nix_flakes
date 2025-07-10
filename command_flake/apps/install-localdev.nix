{ pkgs }:
pkgs.writeShellApplication {
  name = "install-localdev";
  runtimeInputs = with pkgs; [ go ];
  text = ''
    #!/bin/sh
    echo "Installing localdev..."
    GOPRIVATE="github.com/KWRI/*" go install github.com/KWRI/localdev@latest
    echo "localdev installation finished."
  '';
}
