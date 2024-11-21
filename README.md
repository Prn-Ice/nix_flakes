# Nix Flakes Collection

This repository contains a collection of Nix flakes for different development environments.

## What is Nix?

Nix is a powerful package manager and build system that enables reproducible, declarative, and reliable software development environments. Unlike traditional package managers, Nix:

- Ensures reproducible builds across different machines
- Allows multiple versions of packages to coexist
- Supports atomic upgrades and rollbacks
- Prevents dependency conflicts
- Enables declarative system configuration

## Structure

The repository contains two main flakes:

- `cms_flake/`: Development environment for CMS-related work
- `flutter_flake/`: Development environment for Flutter projects

## Getting Started

### Prerequisites

- macOS 10.15 or later
- Administrator access to your machine
- VSCode and Xcode installed

### Installation Steps

1. Install Nix using the Determinate Systems installer (recommended):

   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh
   ```

   - Enter your password when prompted
   - Type 'Y' to proceed with the installation
   - Press enter to complete the installation

2. Install direnv (optional but recommended):

   ```bash
   nix profile install nixpkgs#direnv
   ```

3. Set up direnv with your shell:
   - Add the following to your shell's rc file (e.g., `~/.zshrc` or `~/.bashrc`):

     ```bash
     eval "$(direnv hook zsh)"  # for zsh
     # or
     eval "$(direnv hook bash)" # for bash
     ```

   - Restart your shell or source your rc file

4. Set up VSCode:
   - Install the "Nix" extension pack
   - This will provide syntax highlighting and other Nix-related features

### Setting Up Your Project

1. Clone your project repository (either the CMS or Flutter app):

   ```bash
   # For CMS project
   git clone [cms-repository-url]
   cd [cms-project-directory]

   # Or for Flutter project
   git clone [flutter-repository-url]
   cd [flutter-project-directory]
   ```

2. Create a `.envrc` file in your project directory and add the appropriate use flake command:

   ```bash
   # For CMS development environment
   use flake "github:Prn-Ice/nix_flakes?dir=cms_flake"

   # Or for Flutter development environment
   use flake "github:Prn-Ice/nix_flakes?dir=flutter_flake"
   ```

3. Allow direnv to load the configuration:

   ```bash
   direnv allow
   ```

This will automatically set up the development environment specified by the flake whenever you enter the project directory.
