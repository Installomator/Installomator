#!/bin/sh

# PREVENT Progress 1st swiftDialog from running

# DESCRIPTION
# Will create the file to prevent Progress 1st swiftDialog from running.
# Only for MDM solutions (like Addigy and Microsoft) that have conditions for runnning scripts and do not offer an enrollment event for runnning the script.
# By runninng this script, the file will be created on the client, that will prevent Progress 1st swiftDialog from runnning.
# This is a great help for implementing Progress 1st swiftDialog in a running solution, where the command below have to be run on currently enrolled devices, and then Progress 1st swiftDialog can be assigned to all machines, and will run only on newly enrolled devices.

/usr/bin/touch "/var/db/.Progress1stDone"
