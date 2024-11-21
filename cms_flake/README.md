# CMS Flake

This repository contains a Nix flake for setting up a development environment. This README will guide you through installing and using Nix package manager, particularly on macOS, and how to use this flake.

## What is Nix?

Nix is a powerful package manager and build system that enables reproducible, declarative, and reliable software development environments. Unlike traditional package managers, Nix:

- Ensures reproducible builds across different machines
- Allows multiple versions of packages to coexist
- Supports atomic upgrades and rollbacks
- Prevents dependency conflicts
- Enables declarative system configuration

## Installing Nix on macOS

### Prerequisites

- macOS 10.15 or later
- Administrator access to your machine

### Installation Steps

1. Install Nix using the official installer:

   ```bash
   sh <(curl -L https://nixos.org/nix/install)
   ```

2. Enable Flakes and Nix Command (edit `~/.config/nix/nix.conf` or `/etc/nix/nix.conf`):

   ```bash
   experimental-features = nix-command flakes
   ```

3. Restart your shell or run:

   ```bash
   source ~/.nix-profile/etc/profile.d/nix.sh
   ```

## Using This Flake

### Getting Started

1. Clone this repository:

   ```bash
   git clone [repository-url]
   cd cms_flake
   ```

2. Enter the development environment:

   ```bash
   nix develop
   ```

### Common Commands

- Enter development shell:

   ```bash
   nix develop
   ```

- Build the project:

   ```bash
   nix build
   ```

- Run the project:

   ```bash
   nix run
   ```

### Updating Dependencies

To update the flake's dependencies:

   ```bash
   nix flake update
   ```

## Troubleshooting

### Common Issues

1. If you see "command not found: nix" after installation:
   - Restart your terminal
   - Ensure your shell is properly configured

2. If you encounter permission issues:
   - Ensure Nix is properly installed: `nix --version`
   - Check if the Nix daemon is running: `sudo launchctl list | grep nix`

### Getting Help

- Official Nix documentation: [https://nixos.org/manual/nix/stable/](https://nixos.org/manual/nix/stable/)
- Nix Discord community: [https://discord.gg/RbvHtGa](https://discord.gg/RbvHtGa)
- Nix Forums: [https://discourse.nixos.org/](https://discourse.nixos.org/)

## Contributing

Feel free to open issues or submit pull requests if you find any problems or have suggestions for improvements.

## License

[Specify your license here]
