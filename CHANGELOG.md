## v0.5 - 2021-04-13

- Major update and now with help from @Theile and @Isaac
- Added additional `BLOCKING_PROCESS_ACTION` handlings
- Added additional `NOTIFY=all`. Usuful if used in Self Service, as the user will be notified before download, before install as well as when it is done.
- Added variable `LOGO` for icons i dialogs, use `LOGO=appstore` (or `jamf` or `mosyleb` or `mosylem` or `addigy`). It's also possible to set it to a direct path to a specific icon. Default is `appstore`. 
- Added variable `INSTALL` that can be set to `INSTALL=force` if software needs to be installed even though latest version is already installed (it will be a reinstall).
- Version control now included. The variable `appNewVersion` in a label can be used to tell what the latest version from the web is. If this is not given, version checking is done after download.
- For a label that only installs a pkg without an app in it, a variable `packageID` can be used for version checking. 
- Labels now sorted alphabetically, except for the Microsoft ones (that are at the end of the list). A bunch of new labels added, and lots of them have either been changed or improved (with `appNewVersion` og `packageID`).
- If an app is asked to be closed down, it will now be opened again after the update.
- If your MDM cannot call a script with parameters, the label can be set in the top of the script.
- If your MDM is not Jamf Pro, and you need the script to be installed locally on your managed machines, then take a look at [Theiles fork](https://github.com/Theile/Installomator/). This fork can be called from the MDM using a small script.
- Script `buildCaseStatement.sh` to help with creating labels have been improved.
- Fixed a bug in a variable name that prevented updateTool to be used
- added `type` variable for value `"updateronly"` if the label should only run an updater tool.


## v0.4 - 2020-10-19

- you can now set script variables as an argument in the form `VARIABLE=value`. More detail on this in the README file, 'Configuration from Arguments.' (#26, #50, #72, and #73)
- change `downloadFromGit` to match file types better (#58)
- implemented a workaround for changed behavior of `xpath` in Big Sur (#80)
- added an option `prompt_user_then_kill` to `BLOCKING_PROCESS_ACTION` which will kill the process after the third unsuccessful attempt to quit (#78, thanks Patrick Atoon @raptor399)
- added several new labels for total of 116


## v0.3 - 2020-07-23

- added several new labels for total of 98
- removed the powershell labels, since the installer is not notarized
- when run without any arguments, the script now lists all labels
- changed how zips are expanded because this was broken on Mojave
- improved logging in some statements
- several more minor improvements


## v0.2 - 2020-06-09

- many fixes for broken URLs and other bugs
- the `pkgInDmg` and `pkgInZip` now search for a pkg file in the archive in case the file name varies with the version
- notification on successful installation can be suppressed with the `NOTIFY` variable
- Apple signed installers and apps that don’t have a Team ID are verified correctly now
improved logging
- several new applications: count increased from 62 in 0.1 to 87 in 0.2


## v0.1 - 2020-05-12
