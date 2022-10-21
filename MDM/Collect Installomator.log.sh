#!/bin/sh

# A small script to grab Installomator log from a client Mac.
# Can be sent to the client so the result can be seen in MDM
# Only uncomment the line below for the things you want to see.

logFile="/var/log/Installomator.log"

# Show latest 100 lines of the log
tail -100 "${logFile}"

# Show latest 500 lines but filter to REQ|ERROR|WARN lines
# Great overview of the log
#tail -500 "${logFile}" | grep --binary-files=text -E ": (REQ|ERROR|WARN)"

# Show only one label
# Great to see everything for a label that might fail or not working as expected
label="valuesfromarguments"
#cat "${logFile}" | grep --binary-files=text ": ${label}"
