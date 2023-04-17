# Scripts for use with MDM

These example scripts are meant for use with MDM to run __Installomator__ and process installs. Examples are also included which use swiftDialog to provide user feedback and dockutil to add app icons to the dock.

There are basically two ways to use Installomator with MDM. The _“Jamf way”_ is where, through the MDM admin interface, your upload the Installomator script to a policy, and you provide additional parameters in the policy configuration like which app to install. The _“other way”_ to use Installomator is by having the MDM install Installomator locally on the computer, just once, and then on subsequent runs the MDM runs a script which calls Installomator and provides the parameters.

MDM solutions which needs a local installed __Installomator__ script are Addigy, Mosyle Manager/Mosyle Business, Kandji, Microsoft Endpoint Manager (Intune), and Workspace ONE (AirWatch). At least of the solutions we have tested __Installomator__ with.

The scripts utilizing __swiftDialog__  require version 10 of __Installomator__. If Installomator version 9 is installed, it will set `NOTIFY=all` and use the traditional __Installomator__ notifications for showing progress, where as on version 10 it will be `NOTIFY=silent` as __swiftDialog__ is used instead.

We have split the scripts into two folders

## "Jamf" folder

This folder has Jamf specific examples using __swiftDialog__ as part of the Installomator installation. Perfect for use with Jamf Self Service. Separate [ReadMe-file](Jamf/ReadMe.md) in this folder.

## "MDMs with local installed Installomator" folder

This folder has a collection of scripts that can be great when utilising __Installomator__ with or without __swiftDialog__. Examples are useful for all installations including Self Service. Separate [ReadMe-file](MDMs with local installed Installomator/README.md) in this folder.
