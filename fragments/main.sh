*)
    # unknown label
    #printlog "unknown label $label"
    cleanupAndExit 1 "unknown label $label" ERROR
    ;;
esac

# Are we only asked to return label name
if [[ $RETURN_LABEL_NAME -eq 1 ]]; then
    printlog "Only returning label name." REQ
    printlog "$name"
    echo "$name"
    exit
fi

# MARK: application download and installation starts here

if [[ ${INTERRUPT_DND} = "no" ]]; then
    # Check if a fullscreen app is active
    if hasDisplaySleepAssertion; then
        cleanupAndExit 1 "active display sleep assertion detected, aborting" ERROR
    fi
fi

printlog "BLOCKING_PROCESS_ACTION=${BLOCKING_PROCESS_ACTION}"
printlog "NOTIFY=${NOTIFY}"
printlog "LOGGING=${LOGGING}"

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
        if [[ -z $MDMProfileName ]]; then; MDMProfileName="Mosyle Corporation MDM"; fi
        ;;
    mosylem)
        # Mosyle Manager (education)
        LOGO="/Applications/Manager.app/Contents/Resources/AppIcon.icns"
        if [[ -z $MDMProfileName ]]; then; MDMProfileName="Mosyle Corporation MDM"; fi
        ;;
    addigy)
        # Addigy
        LOGO="/Library/Addigy/macmanage/MacManage.app/Contents/Resources/atom.icns"
        if [[ -z $MDMProfileName ]]; then; MDMProfileName="MDM Profile"; fi
        ;;
    microsoft)
        # Microsoft Endpoint Manager (Intune)
        LOGO="/Library/Intune/Microsoft Intune Agent.app/Contents/Resources/AppIcon.icns"
        if [[ -z $MDMProfileName ]]; then; MDMProfileName="Management Profile"; fi
        ;;
esac
if [[ ! -a "${LOGO}" ]]; then
    if [[ $(sw_vers -buildVersion) > "19" ]]; then
        LOGO="/System/Applications/App Store.app/Contents/Resources/AppIcon.icns"
    else
        LOGO="/Applications/App Store.app/Contents/Resources/AppIcon.icns"
    fi
fi
printlog "LOGO=${LOGO}" INFO

printlog "Label type: $type" INFO

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
printlog "archiveName: $archiveName" INFO

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
            cleanupAndExit 99 "Cannot handle type $type" ERROR
            ;;
    esac
fi

if [[ -z $blockingProcesses ]]; then
    printlog "no blocking processes defined, using $name as default" INFO
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
printlog "Changing directory to $tmpDir" DEBUG
if ! cd "$tmpDir"; then
    cleanupAndExit 1 "error changing directory $tmpDir" ERROR
fi

# MARK: get installed version
getAppVersion
printlog "appversion: $appversion"

# MARK: Exit if new version is the same as installed version (appNewVersion specified)
if [[ "$type" != "updateronly" && ($INSTALL == "force" || $IGNORE_APP_STORE_APPS == "yes") ]]; then
    printlog "Label is not of type “updateronly”, and it’s set to use force to install or ignoring app store apps, so not using updateTool."
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
                cleanupAndExit 0 "No newer version." REQ
            fi
        else
            printlog "DEBUG mode 1 enabled, not exiting, but there is no new version of app." WARN
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
            cleanupAndExit 0 "updateTool has run" REQ
        elif [[ $type == "updateronly" ]];then
            cleanupAndExit 0 "type is $type so we end here." REQ
        fi # otherwise continue
    else
        printlog "DEBUG mode 1 enabled, not running update tool" WARN
    fi
fi

# MARK: download the archive
if [ -f "$archiveName" ] && [ "$DEBUG" -eq 1 ]; then
    printlog "$archiveName exists and DEBUG mode 1 enabled, skipping download"
else
    # download
    printlog "Downloading $downloadURL to $archiveName" REQ
    if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
        printlog "notifying"
        if [[ $updateDetected == "YES" ]]; then
            displaynotification "Downloading $name update" "Download in progress …"
        else
            displaynotification "Downloading new $name" "Download in progress …"
        fi
    fi
    curlDownload=$(curl -v -fsL --show-error ${curlOptions} "$downloadURL" -o "$archiveName" 2>&1)
    curlDownloadStatus=$(echo $?)
    deduplicatelogs "$curlDownload"
    if [[ $curlDownloadStatus -ne 0 ]]; then
    #if ! curl --location --fail --silent "$downloadURL" -o "$archiveName"; then
        printlog "error downloading $downloadURL" ERROR
        message="$name update/installation failed. This will be logged, so IT can follow up."
        if [[ $currentUser != "loginwindow" && $NOTIFY == "all" ]]; then
            printlog "notifying"
            if [[ $updateDetected == "YES" ]]; then
                displaynotification "$message" "Error updating $name"
            else
                displaynotification "$message" "Error installing $name"
            fi
        fi
        printlog "File list: $(ls -lh "$archiveName")" ERROR
        printlog "File type: $(file "$archiveName")" ERROR
        cleanupAndExit 2 "Error downloading $downloadURL error:\n$logoutput" ERROR
    fi
    printlog "File list: $(ls -lh "$archiveName")" DEBUG
    printlog "File type: $(file "$archiveName")" DEBUG
    printlog "curl output was:\n$logoutput" DEBUG
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
printlog "Installing $name" REQ
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
    printlog "installerTool used: $installerTool" REQ
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
        cleanupAndExit 99 "Cannot handle type $type" ERROR
        ;;
esac

# MARK: Finishing — print installed application location and version
finishing

# all done!
cleanupAndExit 0 "All done!" REQ
