# About this fork

| Repo                | URL                                                | Description             |
| ------------------- | -------------------------------------------------- | ----------------------- |
| Upstream (original) | https://github.com/Installomator/Installomator     | Original Repo we forked |
| This Repo           | https://github.com/emersoncollective/Installomator | The repo we modify      |

## Summary

We want to keep this up to date with the upstream. To achieve that, we leverage
the
[actions/upstream-sync](https://github.com/marketplace/actions/upstream-sync)
github action. This process runs on a schedule and can be triggered manually.
See [`.github/workflows/update.yml`](.github/workflows/update.yml) for details.

#### Manual Mode

From an up to date master branch, run the following.

Get the latest version of our clone and get the latest from the upstream.

```bash
git checkout master     # our master
git pull origin master  # get the latest changes
git fetch upstream --all --prune  # get the latest from the upstream
```

Create a new branch with our latest changes from master and rebase this branch
off of the upstream.

```bash
git checkout -b automated-updates/`date "+%Y-%m-%d"`  # create a new branch
git rebase upstream/master
git push
```

In github or via the cli (`hub`), create a new pull request.
