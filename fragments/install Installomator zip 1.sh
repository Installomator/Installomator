#!/bin/sh

#########################################################################################
# install Installomator zip direct
# Source: https://github.com/Installomator/Installomator
# Installomator version
#########################################################################################


# MARK: Constants

# PATH declaration
export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# File locations
install_location="/usr/local/Installomator"
script_file="${install_location}/Installomator.sh"


# use trap
trap 'rm -vf "$script_file"' INT HUP TERM # EXIT


# MARK: Script installation

# zipContent created like this:
# Dump -> zip -> base64
# cat Installomator.sh | gzip -9 | base64 -i - -o -
zipContent=$( cat << 'zipEOF'
