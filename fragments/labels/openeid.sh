openeid)
    name="Open-EID"
    type="pkgInDmg"
    archiveName="Open-EID.pkg"
    downloadURL=$(curl -fs "https://www.id.ee/en/article/install-id-software/" | grep -oe "https://installer.id.ee/media/osx/.*\.dmg")
    appNewVersion=$(echo $downloadURL | sed -E 's/.*EID_|.dmg//g')
    expectedTeamID="ET847QJV9F"
    blockingProcesses=( "EstEIDTokenApp" "EstEIDTokenNotify" "web-eid" )
    appCustomVersion(){ if [[ -d /Applications/Utilities/EstEIDTokenApp.app ]] && [[ -d /Applications/Utilities/web-eid.app ]];then /usr/sbin/pkgutil --pkg-info ee.ria.open-eid | grep "version" | awk '{print$2}';fi }
    ;;
