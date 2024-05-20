pgadmin4)
    name="pgAdmin 4"
    type="dmg"
    downloadParent="https://www.postgresql.org/ftp/pgadmin/pgadmin4/"
    appNewVersion=$(curl -fs "${downloadParent}" | grep -oE 'v[0-9]+.[0-9]+' | sort -V | tail -n 1 | sed 's/v//g')
    downloadURL="https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v$appNewVersion/macos/pgadmin4-$appNewVersion-x86_64.dmg"
    expectedTeamID="TCHGL2R7C5"
    ;;
