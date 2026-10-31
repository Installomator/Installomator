lockdownbrowser)
    name="LockDown Browser"
    type="pkgInZip"
    institutionID="${institutionID:?Institution ID required}"
    versionInfo=$(curl -fs "https://downloads.respondus.com/patches/cmacldb/standard/stdinfo.htm") || cleanupAndExit 2 "Could not retrieve LockDown Browser version information." ERROR
    while read -r line; do
        entry=$(awk -F'[<>]' '{print $3}' <<< "$line")
        minimumOSversion=$(cut -d ',' -f1 <<< "$entry")
        availableVersion=$(cut -d ',' -f2 <<< "$entry")
        downloadAvailable=$(cut -d ',' -f8 <<< "$entry")
        providedDownloadURL=$(cut -d ',' -f10 <<< "$entry")
        if [[ "$downloadAvailable" == "1" ]] && is-at-least "$minimumOSversion" "$installedOSversion" && ([[ -z "$appNewVersion" ]] || ! is-at-least "$availableVersion" "$appNewVersion"); then
            appNewVersion="$availableVersion"
            downloadURL="${${providedDownloadURL/\{instid\}/$institutionID}//\"/}"
        fi
    done < <(grep -E '<osauto>|<osmanual>' <<< "$versionInfo")
    [[ -n "$appNewVersion" ]] || cleanupAndExit 15 "No compatible version of LockDown Browser available." ERROR
    appCustomVersion() { local plist="/Applications/$name.app/Contents/Info.plist"; [[ -f "$plist" ]] || return; echo "$(defaults read "$plist" CFBundleShortVersionString 2>/dev/null).$(defaults read "$plist" LDBMinorBuild 2>/dev/null)"; }
    expectedTeamID="8CA6NAN723"
    blockingProcesses=( "LockDown Browser" )
    ;;
