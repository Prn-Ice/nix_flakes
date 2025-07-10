{ pkgs }:
pkgs.writeShellApplication {
  name = "npm-login";
  runtimeInputs = with pkgs; [ nodejs gnugrep ];
  text = ''
    #!/bin/sh
    echo "Configuring npm registry..."
    npm config set registry https://npm-proxy.fury.io/kellerwilliams/

    printf "\nLogging into npm-proxy.fury.io...\n"
    npm login --registry=https://npm-proxy.fury.io/kellerwilliams/

    printf "\nLogging into npm.fury.io...\n"
    npm login --registry=https://npm.fury.io/kellerwilliams/

    NPMRC_FILE="$HOME/.npmrc"
    AUTH_LINE="//npm-proxy.fury.io/kellerwilliams/:always-auth=true"

    if ! grep -qF -- "$AUTH_LINE" "$NPMRC_FILE"; then
      printf "\n%s\n" "$AUTH_LINE" >> "$NPMRC_FILE"
      echo "Added 'always-auth=true' to $NPMRC_FILE"
    fi

    printf "\nnpm login process complete.\n"
  '';
}
