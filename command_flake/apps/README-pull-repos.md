pull-repos

This package installs a small shell script `pull-repos` that finds all git repositories under `~/Development/work/command` (or a provided path) and runs `git fetch --all --prune` followed by `git pull --ff-only` in each.

Usage:

  pull-repos            # uses ~/Development/work/command
  pull-repos /path/to/dir

Notes:

- The script looks for `.git` directories up to depth 3 from the root. Adjust `find` in `apps/pull-repos.nix` if you need a different depth.
- The script continues after failures and prints a warning per failing repo.
