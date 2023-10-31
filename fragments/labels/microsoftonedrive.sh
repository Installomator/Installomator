microsoftonedrive-deferred|\
microsoftonedrive-rollingout|\
microsoftonedrive-rollingoutdeferred|\
microsoftonedrive)
    # The 4 OneDrive labels have become a mess, with two of them ending up with the same $label name despite different file names.
    #     - This is to fix it and combine them into one label.
    # https://support.microsoft.com/en-us/office/onedrive-release-notes-845dcf18-f921-435e-bf28-4e24b95e5fc0#OSVersion=Mac
    name="OneDrive"
    type="pkg"
    case $label in
        microsoftonedrive-deferred)
            downloadURL="https://go.microsoft.com/fwlink/?linkid=861009"
            # This version should match the Enterprise (Deferred) version setting of OneDrive update channel.
            # So only use this label if that is the channel you use for OneDrive. For default update settings use label “microsoftonedrive”.
        ;;
        microsoftonedrive-rollingout)
            downloadURL="https://go.microsoft.com/fwlink/?linkid=861011"
            # This version is the Rolling out version of OneDrive. Not sure what channel in OneDrive update it matches, maybe Insiders.
        ;;
        microsoftonedrive-rollingoutdeferred)
            downloadURL="https://go.microsoft.com/fwlink/?linkid=861010"
            # This version is the Rolling out Deferred version of OneDrive. Not sure what channel in OneDrive update it matches.
        ;;
        *)
            downloadURL="https://go.microsoft.com/fwlink/?linkid=823060"
            # This version match the Last Released Production version setting of OneDrive update channel.
            # It’s default if no update channel setting for OneDrive updates has been specified.
            # Enterprise (Deferred) is also supported with label “microsoftonedrive-deferred”.
        ;;
    esac
    # The comments in the case statement above are from the original labels. - @wakco
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | cut -d "/" -f 6 | cut -d "." -f 1-3)
    expectedTeamID="UBF8T346G9"
    if [[ "$label" != *"-rollingout"* ]] then
        # Cannot use MAU with rolling out versions as they are more uptodate that what MAU may see.
        # See the release notes (website linked above) for more information.
        if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
            printlog "Running msupdate --list"
            "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
        fi
        updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
        updateToolArguments=( --install --apps ONDR18 )
    fi
    ;;
