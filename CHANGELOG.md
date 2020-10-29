## v0.5 - 2020-

- when Installomator cannot find an app in a dmg with the given appName it will now use the first .app in the root dir. This is for applications which contain the version number in the application name. Note: this might lead to multiple versions of the app in the /Applications directory. You will have to find a different means to clean these up when necessary


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
