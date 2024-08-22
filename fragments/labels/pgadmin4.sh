pgadmin4)
    name="pgAdmin 4"
    type="dmg"
    downloadParent="https://ftp.postgresql.org/pub/pgadmin/pgadmin4/"
    appNewVersion=$(curl -fs "${downloadParent}" | grep -oE 'v\d+\.\d+' | sort --version-sort | tail -n 1 | sed 's/v//g')
    if [[ $(arch) == "arm64" ]]; then
        archLabel="arm64"
    elif [[ $(arch) == "i386" ]]; then
        archLabel="x86_64"
    fi
    downloadURL="${downloadParent}v${appNewVersion}/macos/pgadmin4-${appNewVersion}-${archLabel}.dmg"
    expectedTeamID="TCHGL2R7C5"
    ;;
