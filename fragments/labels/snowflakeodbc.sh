snowflakeodbc)
    name="Snowflake ODBC Driver"
    type="pkgInDmg"
    pkgName="snowflakeODBC.pkg"
    packageID="net.snowflake.odbc"
    odbcRepo="https://sfc-repo.snowflakecomputing.com/odbc/macuniversal"
    appNewVersion=$(curl -fsL "$odbcRepo/" | grep -oE 'href="[0-9]+\.[0-9]+\.[0-9]+/index\.html"' | sed -E 's#href="([0-9]+\.[0-9]+\.[0-9]+)/index\.html"#\1#' | sort -t. -k1,1nr -k2,2nr -k3,3nr | head -n 1)
    downloadURL="$odbcRepo/$appNewVersion/snowflake_odbc_mac_64universal-$appNewVersion.dmg"
    blockingProcesses=( NONE )
    expectedTeamID="W4NT6CRQ7U"
    ;;
