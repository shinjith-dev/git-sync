#!/bin/bash

# Exit immediately in case of error
set -e

# Formatted commit message
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
system_ip=$(hostname -I | awk '{print $1}')
commit_message="chore: sync ${timestamp} ${system_ip}"

# Add changes
echo "ADD: Adding changes"
git add -A

# Commit changes
echo "COMMIT: Committing changes"
git commit -m "$commit_message" || echo "COMMIT: No changes to commit"

# Pull from remote
echo "PULL: Pulling from remote (merge preferred)"
if ! git pull --no-rebase; then
    echo "PULL: Merge failed, attempting rebase..."

    # Attempt rebase
    if ! git pull --rebase; then
        echo "PULL: Rebase also failed, resolving conflicts by resetting to the remote repository!"
        git rebase --abort || true
        git reset --hard origin/$(git rev-parse --abbrev-ref HEAD) || {
            echo "PULL: Failed to reset to remote state. Exiting"
            exit 1
        }
    fi
fi

# Push changes
echo "PUSH: Pushing to remote"
if ! git push; then
    echo "PUSH: Push failed. Attempting to force sync..."
    git fetch --all
    git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)
    git push --force
fi

echo "DONE: git-sync completed successfully"

