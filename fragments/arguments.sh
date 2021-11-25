# MARK: check minimal macOS requirement
autoload is-at-least

if ! is-at-least 10.14 $(sw_vers -productVersion); then
    printlog "Installomator requires at least macOS 10.14 Mojave."
    exit 98
fi

# MARK: argument parsing
if [[ $# -eq 0 ]]; then
    if [[ -z $label ]]; then # check if label is set inside script
        printlog "no label provided, printing labels"
        grep -E '^[a-z0-9\_-]*(\)|\|\\)$' "$0" | tr -d ')|\' | grep -v -E '^(broken.*|longversion|version|valuesfromarguments)$' | sort
        #grep -E '^[a-z0-9\_-]*(\)|\|\\)$' "${labelFile}" | tr -d ')|\' | grep -v -E '^(broken.*|longversion|version|valuesfromarguments)$' | sort
        exit 0
    fi
elif [[ $1 == "/" ]]; then
    # jamf uses sends '/' as the first argument
    printlog "shifting arguments for Jamf"
    shift 3
fi

while [[ -n $1 ]]; do
    if [[ $1 =~ ".*\=.*" ]]; then
        # if an argument contains an = character, send it to eval
        printlog "setting variable from argument $1"
        eval $1
    else
        # assume it's a label
        label=$1
    fi
    # shift to next argument
    shift 1
done

# lowercase the label
label=${label:l}

# separate check for 'version' in order to print plain version number without any other information
if [[ $label == "version" ]]; then
    echo "$VERSION"
    exit 0
fi

printlog "################## Start Installomator v. $VERSION"
printlog "################## $label"

# Check for DEBUG mode
if [[ $DEBUG -gt 0 ]]; then
    printlog "DEBUG mode $DEBUG enabled."
fi

# How we get version number from app
# (alternative is "CFBundleVersion", that can be used in labels)
versionKey="CFBundleShortVersionString"

# get current user
currentUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }')

# MARK: check for root
if [[ "$(whoami)" != "root" && "$DEBUG" -ne 2 ]]; then
    # not running as root
    cleanupAndExit 6 "not running as root, exiting"
fi

# MARK: labels in case statement
case $label in
longversion)
    # print the script version
    printlog "Installomater: version $VERSION ($VERSIONDATE)"
    exit 0
    ;;
valuesfromarguments)
    if [[ -z $name ]]; then
        printlog "need to provide 'name'"
        exit 1
    fi
    if [[ -z $type ]]; then
        printlog "need to provide 'type'"
        exit 1
    fi
    if [[ -z $downloadURL ]]; then
        printlog "need to provide 'downloadURL'"
        exit 1
    fi
    if [[ -z $expectedTeamID ]]; then
        printlog "need to provide 'expectedTeamID'"
        exit 1
    fi
    ;;

# label descriptions start here
