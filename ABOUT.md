# About this fork

## What is it?

## Updates

We want to keep this up to date with the upstream. To achieve that, we will

1. check out the latest version of the upstream
2. rebase our work off of the latest
3. open a pull request with these changes and tag @mattdjerome and @frisson
4. ec tech will review, update, approve, and merge changes as appropriate.

This process will be automated using github actions and set to run on a
schedule. See [`.github/workflows/update.yml`](.github/workflows/update.yml) for
implementation details.

#### Summary

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

### Details

| Repo                | URL                                                | Description             |
| ------------------- | -------------------------------------------------- | ----------------------- |
| Upstream (original) | https://github.com/Installomator/Installomator     | Original Repo we forked |
| This Repo           | https://github.com/emersoncollective/Installomator | The repo we modify      |
