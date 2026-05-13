#!/bin/sh

# PREVENT Installomator 1st Auto-install from running

# DESCRIPTION
# Will create the file to prevent Installomator 1st Auto-install from running.
# Only for MDM solutions (like Addigy and Microsoft) that have conditions for runnning scripts and do not offer an enrollment event for runnning the script.
# By runninng this script, the file will be created on the client, that will prevent Installomator 1st Auto-install from runnning.
# This is a great help for implementing Installomator 1st Auto-install in a running solution, where the command below have to be run on currently enrolled devices, and then Installomator 1st Auto-install can be assigned to all machines, and will run only on newly enrolled devices.

/usr/bin/touch "/var/db/.Installomator1stDone"
