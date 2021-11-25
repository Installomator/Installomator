*)
    # unknown label
    #printlog "unknown label $label"
    cleanupAndExit 1 "unknown label $label"
    ;;
esac


# MARK: application download and installation starts here

printlog "BLOCKING_PROCESS_ACTION=${BLOCKING_PROCESS_ACTION}"
printlog "NOTIFY=${NOTIFY}"

# Finding LOGO to use in dialogs
case $LOGO in
    appstore)
        # Apple App Store on Mac
        if [[ $(sw_vers -buildVersion) > "19" ]]; then
            LOGO="/System/Applications/App Store.app/Contents/Resources/AppIcon.icns"
        else
            LOGO="/Applications/App Store.app/Contents/Resources/AppIcon.icns"
        fi
        ;;
    jamf)
        # Jamf Pro
        LOGO="/Library/Application Support/JAMF/Jamf.app/Contents/Resources/AppIcon.icns"
        ;;
    mosyleb)
        # Mosyle Business
        LOGO="/Applications/Self-Service.app/Contents/Resources/AppIcon.icns"
        ;;
    mosylem)
        # Mosyle Manager (education)
        LOGO="/Applications/Manager.app/Contents/Resources/AppIcon.icns"
        ;;
    addigy)
        # Addigy
        LOGO="/Library/Addigy/macmanage/MacManage.app/Contents/Resources/atom.icns"
        ;;
esac
if [[ ! -a "${LOGO}" ]]; then
    if [[ $(sw_vers -buildVersion) > "19" ]]; then
        LOGO="/System/Applications/App Store.app/Contents/Resources/AppIcon.icns"
    else
        LOGO="/Applications/App Store.app/Contents/Resources/AppIcon.icns"
    fi
fi
printlog "LOGO=${LOGO}"

# MARK: extract info from data
if [ -z "$archiveName" ]; then
    case $type in
        dmg|pkg|zip|tbz)
            archiveName="${name}.$type"
            ;;
        pkgInDmg)
            archiveName="${name}.dmg"
            ;;
        *InZip)
            archiveName="${name}.zip"
            ;;
        updateronly)
            ;;
        *)
            printlog "Cannot handle type $type"
            cleanupAndExit 99
            ;;
    esac
fi

if [ -z "$appName" ]; then
    # when not given derive from name
    appName="$name.app"
fi

if [ -z "$targetDir" ]; then
    case $type in
        dmg|zip|tbz|app*)
            targetDir="/Applications"
            ;;
        pkg*)
            targetDir="/"
            ;;
        updateronly)
            ;;
        *)
            printlog "Cannot handle type $type"
            cleanupAndExit 99
            ;;
    esac
fi

if [[ -z $blockingProcesses ]]; then
    printlog "no blocking processes defined, using $name as default"
    blockingProcesses=( $name )
fi

# MARK: determine tmp dir
if [ "$DEBUG" -eq 1 ]; then
    # for debugging use script dir as working directory
    tmpDir=$(dirname "$0")
else
    # create temporary working directory
    tmpDir=$(mktemp -d )
fi

# MARK: change directory to temporary working directory
printlog "Changing directory to $tmpDir"
if ! cd "$tmpDir"; then
    printlog "error changing directory $tmpDir"
    cleanupAndExit 1
fi

# MARK: get installed version
getAppVersion
printlog "appversion: $appversion"

# MARK: Exit if new version is the same as installed version (appNewVersion specified)
# credit: Søren Theilgaard (@theilgaard)
if [[ $INSTALL == "force" ]]; then
    printlog "Using force to install, so not using updateTool."
    updateTool=""
fi
if [[ -n $appNewVersion ]]; then
    printlog "Latest version of $name is $appNewVersion"
    if [[ $appversion == $appNewVersion ]]; then
        if [[ $DEBUG -ne 1 ]]; then
            printlog "There is no newer version available."
            if [[ $INSTALL != "force" ]]; then
                message="$name, version $appNewVersion, is  the latest version."
                if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
                    printlog "notifying"
                    displaynotification "$message" "No update for $name!"
                fi
                cleanupAndExit 0 "No newer version."
            fi
        else
            printlog "DEBUG mode 1 enabled, not exiting, but there is no new version of app."
        fi
    fi
else
    printlog "Latest version not specified."
fi

# MARK: check if this is an Update and we can use updateTool
if [[ (-n $appversion && -n "$updateTool") || "$type" == "updateronly" ]]; then
    printlog "appversion & updateTool"
    if [[ $DEBUG -ne 1 ]]; then
        if runUpdateTool; then
            finishing
            cleanupAndExit 0
        elif [[ $type == "updateronly" ]];then
            printlog "type is $type so we end here."
            cleanupAndExit 0
        fi # otherwise continue
    else
        printlog "DEBUG mode 1 enabled, not running update tool"
    fi
fi

# MARK: download the archive
if [ -f "$archiveName" ] && [ "$DEBUG" -eq 1 ]; then
    printlog "$archiveName exists and DEBUG mode 1 enabled, skipping download"
else
    # download the dmg
    printlog "Downloading $downloadURL to $archiveName"
    if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
        printlog "notifying"
        if [[ $updateDetected == "YES" ]]; then
            displaynotification "Downloading $name update" "Download in progress …"
        else
            displaynotification "Downloading new $name" "Download in progress …"
        fi
    fi
    if ! curl --location --fail --silent "$downloadURL" -o "$archiveName"; then
        printlog "error downloading $downloadURL"
        message="$name update/installation failed. This will be logged, so IT can follow up."
        if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
            printlog "notifying"
            if [[ $updateDetected == "YES" ]]; then
                displaynotification "$message" "Error updating $name"
            else
                displaynotification "$message" "Error installing $name"
            fi
        fi
        cleanupAndExit 2
    fi
fi

# MARK: when user is logged in, and app is running, prompt user to quit app
if [[ $BLOCKING_PROCESS_ACTION == "ignore" ]]; then
    printlog "ignoring blocking processes"
else
    if [[ $currentUser != "loginwindow" ]]; then
        if [[ ${#blockingProcesses} -gt 0 ]]; then
            if [[ ${blockingProcesses[1]} != "NONE" ]]; then
                checkRunningProcesses
            fi
        fi
    fi
fi

# MARK: install the download
printlog "Installing $name"
if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
    printlog "notifying"
    if [[ $updateDetected == "YES" ]]; then
        displaynotification "Updating $name" "Installation in progress …"
    else
        displaynotification "Installing $name" "Installation in progress …"
    fi
fi

if [ -n "$installerTool" ]; then
    # installerTool defined, and we use that for installation
    printlog "installerTool used: $installerTool"
    appName="$installerTool"
fi

case $type in
    dmg)
        installFromDMG
        ;;
    pkg)
        installFromPKG
        ;;
    zip)
        installFromZIP
        ;;
    tbz)
        installFromTBZ
        ;;
    pkgInDmg)
        installPkgInDmg
        ;;
    pkgInZip)
        installPkgInZip
        ;;
    appInDmgInZip)
        installAppInDmgInZip
        ;;
    *)
        printlog "Cannot handle type $type"
        cleanupAndExit 99
        ;;
esac

# MARK: Finishing — print installed application location and version
finishing

# all done!
cleanupAndExit 0
