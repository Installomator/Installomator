lockdownbrowser)
    name="LockDown Browser"
    type="pkgInZip"
    [[ "$institutionID" =~ ^[0-9]+$ ]] || cleanupAndExit 89 "lockdownbrowser requires a numeric institutionID argument, e.g. institutionID=123456789" ERROR
    ldbInfo=$(curl -fs "https://downloads.respondus.com/patches/cmacldb/standard/stdinfo.htm") || cleanupAndExit 50 "Could not retrieve LockDown Browser version information." ERROR
    ldbBuild=""
    ldbURL=""
    while read -r ldbLine; do
        ldbEntry=$(awk -F'[<>]' '{print $3}' <<< "$ldbLine")
        ldbMinOS=$(cut -d ',' -f1 <<< "$ldbEntry")
        ldbAvailBuild=$(cut -d ',' -f5 <<< "$ldbEntry")
        ldbAvailable=$(cut -d ',' -f8 <<< "$ldbEntry")
        ldbProvidedURL=$(cut -d ',' -f10 <<< "$ldbEntry")
        if [[ "$ldbAvailable" == "1" ]] && is-at-least "$ldbMinOS" "$installedOSversion" && { [[ -z "$ldbBuild" ]] || ! is-at-least "$ldbAvailBuild" "$ldbBuild"; }; then
            ldbBuild="$ldbAvailBuild"
            ldbURL="${${ldbProvidedURL//\"/}/\{instid\}/$institutionID}"
        fi
    done < <(grep -E '<osauto>|<osmanual>' <<< "$ldbInfo")
    [[ -n "$ldbBuild" && -n "$ldbURL" ]] || cleanupAndExit 15 "No LockDown Browser build available for macOS $installedOSversion." ERROR
    downloadURL="${ldbURL/#http:/https:}"
    appNewVersion="$ldbBuild"
    versionKey="CFBundleVersion"
    expectedTeamID="8CA6NAN723"
    ;;
