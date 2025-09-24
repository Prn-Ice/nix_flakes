{ pkgs }:
pkgs.writeShellApplication {
  name = "pull-repos";
  runtimeInputs = with pkgs; [
    git
    coreutils
  ];
  text = ''
    #!/usr/bin/env sh
    # Pull all git repositories under the command workspace
    # Usage: pull-repos [path]
    # Be robust when the environment enables nounset (set -u)
    if [ "$#" -ge 1 ]; then
      ROOT="$1"
    else
      ROOT="$HOME/Development/work/command"
    fi

    if [ ! -d "$ROOT" ]; then
      echo "Directory $ROOT does not exist." >&2
      exit 2
    fi

    find "$ROOT" -maxdepth 3 -type d -name .git | while read -r gitdir; do
      repo_dir=$(dirname "$gitdir")
      echo "--- Pulling in $repo_dir ---"
      if [ -d "$repo_dir" ]; then
        # Enter repo and try to pull (preserve exit code per-repo)
        (cd "$repo_dir" && printf 'Fetching for %s\n' "$repo_dir" && git fetch --all --prune && git pull --ff-only) ||
          printf 'Warning: pull failed for %s\n' "$repo_dir" >&2
      fi
    done

    echo "Done."
  '';
}
