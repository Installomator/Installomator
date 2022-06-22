clickshare)
    name="ClickShare"
    type="appInDmgInZip"
    downloadURL="https://www.barco.com$( curl -fs "https://www.barco.com/en/clickshare/app" | grep -A6 -i "macos" | grep -i "FileNumber" | tr '"' "\n" | grep -i "FileNumber" )"
    appNewVersion="$(eval "$( echo $downloadURL | sed -E 's/.*(MajorVersion.*BuildVersion=[0-9]*).*/\1/' | sed 's/&amp//g' )" ; ((MajorVersion++)) ; ((MajorVersion--)); ((MinorVersion++)) ; ((MinorVersion--)); ((PatchVersion++)) ; ((PatchVersion--)); ((BuildVersion++)) ; ((BuildVersion--)); echo "${MajorVersion}.${MinorVersion}.${PatchVersion}-b${BuildVersion}")"
    expectedTeamID="P6CDJZR997"
    ;;
