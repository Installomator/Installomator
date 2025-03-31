# NOTE: check minimal macOS requirement
autoload is-at-least

installedOSversion=$(sw_vers -productVersion)
if ! is-at-least 10.14 $installedOSversion; then
    printlog "Installomator requires at least macOS 10.14 Mojave." ERROR
    exit 98
fi

# MARK: argument parsing
if [[ $# -eq 0 ]]; then
    if [[ -z $label ]]; then # check if label is set inside script
        printlog "no label provided, printing labels" REQ
        grep -E '^[a-z0-9\_-]*(\)|\|\\)$' "$0" | tr -d ')|\' | grep -v -E '^(broken.*|longversion|version|valuesfromarguments)$' | sort
        #grep -E '^[a-z0-9\_-]*(\)|\|\\)$' "${labelFile}" | tr -d ')|\' | grep -v -E '^(broken.*|longversion|version|valuesfromarguments)$' | sort
        exit 0
    fi
elif [[ $1 == "/" ]]; then
    # jamf uses sends '/' as the first argument
    printlog "shifting arguments for Jamf" REQ
    shift 3
fi

# first argument is the label
label=$1

# lowercase the label
label=${label:l}

# MARK: Case statement to filter (long) version checks
case $label in
version)
    echo "$VERSION"
    exit 0
    ;;
longversion)
    # print the script version
    echo "Installomator: version $VERSION ($VERSIONDATE)"
    exit 0
    ;;
*)

    # MARK: reading rest of the arguments
    argumentsArray=()
    while [[ -n $1 ]]; do
        if [[ $1 =~ ".*\=.*" ]] || [[ $1 =~ "appCustomVersion.*" ]]; then
            # if an argument contains an = character, send it to eval
            printlog "setting variable from argument $1" INFO
            argumentsArray+=( $1 )
            eval $1
        fi
        # shift to next argument
        shift 1
    done
    printlog "Total items in argumentsArray: ${#argumentsArray[@]}" INFO
    printlog "argumentsArray: ${argumentsArray[*]}" INFO

    # Check if we're in debug mode, if so then set logging to DEBUG, otherwise default to INFO
    # if no log level is specified.
    if [[ $DEBUG -ne 0 ]]; then
        LOGGING=DEBUG
    elif [[ -z $LOGGING ]]; then
        LOGGING=INFO
        datadogLoggingLevel=INFO
    fi

    # NOTE: Use proxy for network access if defined
    if [[ -n $PROXY ]]; then
        printlog "Proxy defined: $PROXY, testing access to it" REQ
        proxyAddress=$(echo $PROXY | cut -d ":" -f1)
        portNumber=$(echo $PROXY | cut -d ":" -f2)
        printlog "Proxy: $proxyAddress, Port: $portNumber"
        if cmdOutput=$(! nc -z -v -G 10 ${proxyAddress} ${portNumber} 2>&1) ; then
            printlog "$cmdOutput" REQ
            printlog "ERROR : No proxy connection, skipping this." REQ
        else
            printlog "Proxy access detected, so using that." REQ
            export ALL_PROXY="$PROXY"
        fi
    fi

    # If we are able to detect an MDM URL (Jamf Pro) or another identifier for a customer/instance we grab it here, this is useful if we're centrally logging multiple MDM instances.
    if [[ -f /Library/Preferences/com.jamfsoftware.jamf.plist ]]; then
        mdmURL=$(defaults read /Library/Preferences/com.jamfsoftware.jamf.plist jss_url)
    elif [[ -n "$MDMProfileName" ]]; then
        mdmURL=$(sudo profiles show | grep -A3 "$MDMProfileName" | sed -n -e 's/^.*organization: //p')
    else
        mdmURL="Unknown"
    fi

# MARK: START
    printlog "################## Start Installomator v. $VERSION, date $VERSIONDATE" REQ
    printlog "################## Version: $VERSION" INFO
    printlog "################## Date: $VERSIONDATE" INFO
    printlog "################## $label" INFO

    # Check for DEBUG mode
    if [[ $DEBUG -gt 0 ]]; then
        printlog "DEBUG mode $DEBUG enabled." DEBUG
    fi

    # get current user
    currentUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }')

    # NOTE: check for root
    if [[ "$(whoami)" != "root" && "$DEBUG" -eq 0 ]]; then
        # not running as root
        cleanupAndExit 6 "not running as root, exiting" ERROR
    fi

    # check Swift Dialog presence and version
    DIALOG_CMD="/usr/local/bin/dialog"

    if [[ ! -x $DIALOG_CMD ]]; then
        # Swift Dialog is not installed, clear cmd file variable to ignore
        printlog "SwiftDialog is not installed, clear cmd file var"
        DIALOG_CMD_FILE=""
    fi

    # prepare github
    githubAUTH=()
    if [[ -n $GITHUBAPI ]]; then
        githubAUTH=( --header "Authorization: Bearer $GITHUBAPI" )
        checkRATEfromGit API
        githubauthfail=$?
        if [ $githubauthfail -gt 0 ]; then
            githubAUTH=()
            printlog "ignoring GITHUBAPI due to access issues ($(case $githubauthfail in 1) echo "no access, is the token correct? does it exist?" ;; 2) echo "insufficient access, public_repo, and read:packages are required" ;; *) echo "unknown" ;; esac)" WARN
        fi
    fi

# MARK: labels in case statement
    case $label in
    valuesfromarguments)
        # no action necessary, all values should be provided in arguments
        ;;

# label descriptions start here
