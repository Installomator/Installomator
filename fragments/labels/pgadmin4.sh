pgadmin4)
	# An open-source management tool for PostgreSQL that offers a feature-rich environment for database development and administration, including a graphical interface for executing SQL queries, managing databases, and visualizing data
    name="pgAdmin 4"
    type="dmg"
    downloadParent="https://www.postgresql.org/ftp/pgadmin/pgadmin4/"
    appNewVersion=$(curl -fs "${downloadParent}" | grep -oE 'v[0-9]+.[0-9]+' | sort -V | tail -n 1 | sed 's/v//g')
    if [[ $(arch) == i386 ]]; then
       downloadURL="https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v$appNewVersion/macos/pgadmin4-$appNewVersion-x86_64.dmg"
    elif [[ $(arch) == arm64 ]]; then
       downloadURL="https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v$appNewVersion/macos/pgadmin4-$appNewVersion-arm64.dmg"
    fi
    expectedTeamID="TCHGL2R7C5"
    ;;