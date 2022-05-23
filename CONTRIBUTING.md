# Contributing to Installomator

__Please note, that if you are contributing to this project with new labels or other suggestions in PRs, please put your changes in the files in the `fragments` sub-folder. DO NOT edit the full `Installomator.sh` script. The full script is generated from the fragments, and will be overwritten. More details on [how the script is assembled from the fragments here](https://github.com/Installomator/Installomator/tree/main/utils#how-to-assemble-installomatorsh).__

We try to keep the script as short as possible, and with more than 400 labels, we can save 400 lines in the script, if we do not have credit lines on each of these. So we are thankful for your contribution, but we will be removing these lines in the coming releases.

## Branches

The branch list is as follows:

- `release`: this branch will have the latest released version
- `main`: (default) this branch will be the current build we are working on. It includes new and updated app labels, and critical bug fixes
- `dev`: this will contain new and updated app labels, as well as other code changes that have the risk of significantly changing or breaking behavior
there will be other branches for new features and testing.

This should allow the contributing team to release minor updates for new and updated app labels while also work on new features for the next major release.

With all the new branches, your local repo may get confused. If you don’t have local changes, it is easiest to delete your local repo and re-clone it. If you have local changes you want to preserve, then you should commit those to a local branch, pull the latest changes `git pull --all`, then delete the old master branch: `git branch -d master`.

Please make sure you branch off of main for your PRs.

__Thank you for contributing!__

## Labels

If you need a new label for a piece of software, please take a look [at the tutorials in the Wiki](https://github.com/Installomator/Installomator/wiki#tutorials), those can be helpful for starting out on the creation of the label.

We expect you to try out finding the __version__ of the software online, so that `appNewVersion` can be filled in the label. It helps a lot when the software needs update, and greatly improve user experience.

Please document what you found out about the __version__ of the software if it's not included. We will not accept a new label if this is not documented, we will ask about this if it was not included. This is very important for the quality and reliability of Installomator.

When creating a new label, please file a pull request (PR). And feel free to ask questions or make your comments about what else is needed, if we should take a look at the label, or help out in finding the version or isolating URLs or anything else. You can find [a tutorial on how to create a PR here](https://github.com/Installomator/Installomator/wiki/GitHub-howto-create-PRs).

Please include the log of installing this label in the description, like this:
```
% /Users/st/Documents/GitHub/Installomator/utils/assemble.sh software
2021-11-24 10:07:19 software ################## Start Installomator v. 0.8.0
2021-11-24 10:07:19 software ################## software
2021-11-24 10:07:19 software DEBUG mode 1 enabled.
```

Please have one label per PR, so we can separate these. Also if you change/fix a label.

__Thank you very much for your contribution!__


## Issues

Do not create an issue just when you have a questions, but do file an issue or pull request (PR) for bugs or wrong behavior. Include the full log and include the version of Installomator you're running. When you create a PR to follow-up and solve an issue make sure to [mention the issue using the `#xxx` syntax in a commit message or comment to link the issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue).

Join [the MacAdmins Slack](https://macadmins.org) and find us in the `#installomator` channel for questions, support and discussions. 

When in doubt, use the MacAdmins.org Slack as described in [README.md](https://github.com/Installomator/Installomator/)
