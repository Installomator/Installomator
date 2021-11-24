# Contributing to Installomator

__Please note, that if you are contributing to this project with new labels or other suggestions in PRs, please put your changes in the files below `fragments`-folder. DO NOT edit the full `Installomator.sh` script. The full script is now a build of the fragments, and will be overwritten.__

We try to keep the script as short as possible, and with more than 300 labels, we can save 300 lines in the script, if we do not have credit lines on each of these. So we are thankful for your contribution, but we will be removing these lines in the coming releases.

## Labels

If you need a new label for a piece of software, please take a look at the tutorials in the Wiki, if those can be helpful for starting out on the creation of the label.

We expect you to try out finding the __version__ of the software online, so that `appNewVersion` can be filled in the label. It helps a lot when the software needs update, and greatly improve user experience.

Please document what you found out about the __version__ of the software if it's not included. We will not accept a new label if this is not documented, we will ask about this if it was not included. This is very important for the quality and reliability of Installomator.

When creating a new label, please file a pull request (PR). And feel free to ask questions or make your comments about what else is needed, if we should take a look at the label, or help out in finding the version or isolating URLs or anything else.

Please include the log of installing this label in the description, like this:
```
% /Users/st/Documents/GitHub/Installomator/utils/assemble.sh software
2021-11-24 10:07:19 software ################## Start Installomator v. 0.8.0
2021-11-24 10:07:19 software ################## software
2021-11-24 10:07:19 software DEBUG mode 1 enabled.
```

Please have one label per PR, so we can separate these. Also if you change/fix a label.

Thank you very much for your contribution!


## Issues

Do not create an issue just when you have a questions, but do file an issue or pull request (PR) for bugs or wrong behavior. Include the full log and include the version of Installomator you're running.

When in doubt, use the MacAdmins.org Slack as described in [README.md](https://github.com/Installomator/Installomator/)
