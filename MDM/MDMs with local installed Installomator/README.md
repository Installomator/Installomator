# Scripts for use with MDMs that require a local installed __Installomator__

Some MDM solutions cannot handle the full __Installlomator__ script and run that using the various paramaters, as Jamf pro can do.

In these solutions we need to have __Installomator__ to be installed locally on the Mac itself, and then call it from there.

MDM solutions which needs a local installed __Installomator__ script are Addigy, Mosyle Manager/Mosyle Business, Kandji, Microsoft Endpoint Manager (Intune), and Workspace ONE (AirWatch). At least of the solutions we have tested __Installomator__ with.

The scripts utilizing __swiftDialog__  require version 10 of __Installomator__. If Installomator version 9 is installed, it will set `NOTIFY=all` and use the traditional __Installomator__ notifications for showing progress, where as on version 10 it will be `NOTIFY=silent` as __swiftDialog__ is used instead.

It is __highly recommended__ to setup a scheduled run of the installation of the newest _Installomator_ as well as the latest __SwiftDialog__. See “Scripts to install prerequisites” below.

## Abbreviations used in script names

- SS — Self Service — scripts designed for use through a Self Service catalog
- VFA — valuesfromarguments — a custom label call to Installomator. When using an MDM and the "other way", you can use these scripts to provide the label variables to Installomator for custom labels.

## Condition scripts

Scripts with the `condition` suffix are for use with MDMs like Addigy, where a script is run to determine if the rest of the policy should run.

## Prevention scripts

The `Installomator 1st` and `Progress 1st` scripts are meant to run automatically upon device enrollment. They check for the existance of a file in certain MDMs, `/var/db/.Installomator1stDone`, to determine whether the computer has already been deployed. You can run the prevention scripts on existing Macs to ensure the 1st scripts won’t inadvertently run on them.

# Scripts to install prerequisites

Use these scripts to handle installing Installomator itself. Additionally, you may want to install swiftDialog manually instead of having Installomator install it.

- `install Installomator direct.sh` — can be run at enrollment and as maintenance at any time to install __Installomator__.

- `install swiftDialog direct.sh` — can be used at enrollment and as maintenance at any time to install __swiftDialog__.

Once Installomator has been installed, __dockutil__ can be installed by Installomator, using this script:

- `App-install/App service Auto-install.sh` — This script uses pre-installed installomator to install __dockutil__.

# Enrollment scripts

For enrollment purposes, some 1st-scripts has been created. One runs silently, another is using __DEPNotify__ to show progress and feedback:

- `Installomator 1st Auto-install DEPNotify.sh` — will install __DEPNotify__ first, start that up, and change progress on the installation bar at each installed label. Very good for Addigy an Microsoft.

- `Installomator 1st Auto-install.sh` — runnning silently installing Installomator labels in the given order. Can be used in combination with the Progress-script.

- `Progress 1st swiftDialog.sh` — It will install __swiftDialog__ and start that up with a list of software it will look for. It will look for an installed file/folder in the file system for each item. This is great if some apps are being installed outside of Installomator, like by Apple Apps & Books, and then this script can show when it has been installed. 

There are also Self Service versions of the above.

## “App-install”-folder

- App browser-security Auto-install.sh
- App browser-security SS.sh
- App normal Auto-install.sh
- App normal SS.sh
- App service Auto-install.sh
- App VFA.sh

Here you can use scripts for Self Service (SS) or for Auto-install. There will be a difference in how many notifications will be used and maybe handling of blocking processes.

`browser-security`: For an app like a web browser, you’ll want the install performed right away, so there isn’t a deferral option.
`normal`: The user can defer/skip the update.
`service`: These are apps where we don’t need to ask the user to allow the update. Menu bar apps and utilities would fall under this category.

## “App-install SS with swiftDialog and dockutil”-folder

- App browser-security SS.sh
- App normal SS multi-app.sh
- App normal SS.sh
- App service SS.sh
- App VFA SS github.sh
- App VFA SS.sh

These scripts are similar to the App-install folder but also utilize __swiftDialog__ to show user feedback and installation status, and they also have an option to use __dockutil__ to add the installed software to the Dock.

# App-update

A common requested behavior is to only update an app if it is already installed. These script verifies if the app is already installed before runnning Installomator.

- App browser-security Auto-install.sh
- App normal Auto-install.sh
