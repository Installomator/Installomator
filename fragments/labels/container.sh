container)
    name="container"
    type="pkg"
    archiveName="container-[0-9.]*-installer-signed.pkg"
    downloadURL="$(downloadURLFromGit apple container)"
    appNewVersion="$(versionFromGit apple container)"
    appCustomVersion() { /usr/local/bin/container --version  2>/dev/null | awk '{print $3}' }
    expectedTeamID="UPBK2H6LZM"
    ;;
