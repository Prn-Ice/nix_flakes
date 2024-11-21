# Nix Flakes Collection

This repository contains a collection of Nix flakes for different development environments.

## Structure

The repository contains two main flakes:

- `cms_flake/`: Development environment for CMS-related work
- `flutter_flake/`: Development environment for Flutter projects

## Usage with direnv

This project is designed to be used with [direnv](https://direnv.net/), which allows for environment-specific development configurations.

### Setup

1. Make sure you have both [Nix](https://nixos.org/) and [direnv](https://direnv.net/) installed on your system.
2. Enable flakes in your Nix configuration if you haven't already.

### Using a Flake

To use any of the flakes in your project:

1. Create a `.envrc` file in your project directory
2. Add the appropriate use flake command. For example:

    ```bash
    # For CMS development environment
    use flake "github:Prn-Ice/nix_flakes?dir=cms_flake"

    # For Flutter development environment
    use flake "github:Prn-Ice/nix_flakes?dir=flutter_flake"
    ```

3. Allow direnv to load the new configuration:

```bash
direnv allow
```

This will automatically set up the development environment specified by the flake whenever you enter the directory.
