#!/bin/zsh --no-rcs
# shellcheck shell=bash # zsh differences disabled
# shellcheck disable=SC2086,SC2001,SC1111,SC1112 #,SC2143,SC2145,SC2089,SC2090
# shellcheck disable=SC2206,SC2296,SC1058,SC1063,SC1072,SC1073,SC2068


#########################################################################################
# install Installomator zip direct
# userSetup v. 3.2, Installer v. 2.7
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
