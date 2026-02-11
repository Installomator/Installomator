container)
    name="container"
    type="pkg"
    archiveName="container-[0-9.]*-installer-signed"
    downloadURL="$(downloadURLFromGit apple container)"
    appNewVersion="$(versionFromGit apple container)"
    appCustomVersion(){
        if [ -f /usr/local/bin/container ];then
            /usr/local/bin/container --version | awk '{print $3}'
        fi
    }
    expectedTeamID="UPBK2H6LZM"
    ;;
