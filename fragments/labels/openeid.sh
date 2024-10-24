openeid)
    name="Open-EID"
    type="pkgInDmg"
    appName="EstEIDTokenApp.app"
    archiveName="Open-EID.pkg"
    downloadURL=$(curl -fs "https://www.id.ee/en/article/install-id-software/" | grep -oe "https://installer.id.ee/media/osx/.*\.dmg")
    appNewVersion=$(echo $downloadURL | sed -E 's/.*EID_|.dmg//g')
    expectedTeamID="ET847QJV9F"
    ;;
