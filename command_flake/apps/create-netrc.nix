{pkgs}:
pkgs.writeShellApplication {
  name = "create-netrc";
  runtimeInputs = with pkgs; [coreutils];
  text = ''
    #!/bin/sh
    if [ "$#" -ne 2 ]; then
        echo "Usage: $0 <username> <password>"
        exit 1
    fi
    cat > ~/.netrc <<EOF
    machine github.com
      login $1
      password $2
    EOF
    chmod 600 ~/.netrc
    echo "$HOME/.netrc created successfully."
  '';
}
