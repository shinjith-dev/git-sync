# git-sync
Shell script for syncing updates to GitHub. Mainly intended for usage in automated sync cases, such as a cronjob.

**!!WARNING!!**
------
This script is likely immature and requires proper revision; use at your own risk. In the worst-case situation, you may end up with a messy git folder or repository.

## Control Flow
1. Add changes (if exists)
2. Commit changes (if exists)
3. Pull from remote
   - Merge preferred pull, if fails due to conflicts or other reasons
   - Tries rebasing from remote, again if that fails
   - Reset to remote repo, if somehow that doen't work
   - Exit
4. Pushing to remote
   - Tries to push, if by any reason such as conflict resolution mistake fails
   - Resets to remote repo, and pushes
5. Finish
