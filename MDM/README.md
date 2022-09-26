# MDM scripts

This is a long list of various scripts for certain use in MDM solutions that cannot call a script internally with parameters, like Jamf Pro can do it.

So for Mosyle, Addigy, and Microsoft Endpoint Manager (Intune), these are know to be good. If these works in other MDMs, let us know. 

Especially for Addigy, and maybe also for other MDMs, `condition`-scripts has been added if software installation will run on certain conditions. Also `prevention`-scripts has been added, if you manually need to eliminate the runnning of a script, this can be needed if you want to use the enrollment script, but don’t want it to run on the currently managed Macs Then you should sent out the `prevention`-script to make sure the file it creates is present on the Macs so the ordinary script will not do anything (it will detect this file and stop if found).

### Shortenings

- SS — Self Service — scripts designed for use through a Self Service catalog
- VFA — valuesfromarguments — a custom label call to Installomator

# To be installed on all the Macs

In order for our MDM scripts to work, we need Installomator locally installed using the pkg we provide in our release.

So I suggest to install these on enrollment.

To utilize swiftDialog, we also need that installed.

If you need dockutil, that should be maintained as well, but if missing the MDM scripts will install it.

## Maintenance of Installomator, swiftDialog, and dockutil

I suggest to check weekly, and maybe at each boot, it newer versions have been released of these tools.

The verious MDMs have various ways of running scheduled, but it is possible.

### Scripts to use for installing these components

These do not require anything to be installed on macOS:

- `install Installomator direct.sh` — can be run at enrollment and as maintenance at any time to install __Installomator__.

- `install swiftDialog direct.sh` — can be used at enrollment and as maintenance at any time to install __swiftDialog__.

Once Installomator has been installed, __dockutil__ can be installed using Installomator (as a service), using this script:

- `App-install/App service Auto-install.sh` — This script uses pre-installed installomator to install dockutil.

# Enrollment scripts

For enrollment purposes, som 1st-scripts has been created. One is not showing anything to the end-user while running and another is using __DEPNotify__ to show progress (so hopefully the user will wait for the installation to finish):

- `Installomator 1st Auto-install DEPNotify.sh` — will install __DEPNotify__ first, start that up, and change progress on the installation bar at each installed label. Very good for Addigy.

- `Installomator 1st Auto-install.sh` — runnning silently installing Installomator labels in the given order. Can be used in combination with the Progress-script.

- `Progress 1st swiftDialog.sh` — It will install __swiftDialog__ and start that up with a list of software it will look for. It will look for an installed file/folder in the file system for each item. This is great for Mosyle that can install software using various methods, and then this script can show when it has been installed. 

There are also Self Service scripts for this, if it’s somehow needed to have users running the installation manually.

# App-installation

Two different kinds of App-installation scripts have been made. Some that is very similar to the old provided scripts that are only using __Installomator__ for notifications (if any). And others that can use __swiftDialog__ for installation progress, and can also add the app to the Dock using __dockutil__.

## “App-install”-folder

- App browser-security Auto-install.sh
- App browser-security SS.sh
- App normal Auto-install.sh
- App normal SS.sh
- App service Auto-install.sh
- App VFA.sh

Here you can use scripts for Self Service (SS) or for Auto-install. THere will be a difference in how many notifications will be used and maybe handling of blocking processes.

What is also differentiated is what kind of app it is. Is it of the kind of browser, that can often have critical security fixes, then we don’t want the user to postpone the installation, wheras a normal app can wait. A service app do not have to ask before installing, and should be able to install regardsliess if the app is currently running.

## “App-install SS with swiftDialog and dockutil”-folder

- App browser-security SS.sh
- App normal SS multi-app.sh
- App normal SS.sh
- App service SS.sh
- App VFA SS github.sh
- App VFA SS.sh

All of the notes for the above scripts are the same for these.

But these scripts utilize __swiftDialog__ to show a more live progress for the installation, and they also have a setting to use __dockutil__ to add the software to the Dock of the user.
