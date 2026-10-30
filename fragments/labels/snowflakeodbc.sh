snowflakeodbc)
	name="Snowflake ODBC Driver"
	type="pkgInDmg"
	pkgName="snowflakeODBC.pkg"
	packageID="net.snowflake.odbc"
	expectedTeamID="W4NT6CRQ7U"
	odbcYear=$(date +%Y)
	appNewVersion=$(curl -fsL "https://docs.snowflake.com/en/release-notes/clients-drivers/odbc-${odbcYear}" | grep -oE "Version [0-9]+\.[0-9]+\.[0-9]+" | head -1 | awk '{print $2}')
	if [[ -z "$appNewVersion" ]]; then
		odbcYear=$((odbcYear - 1))
		appNewVersion=$(curl -fsL "https://docs.snowflake.com/en/release-notes/clients-drivers/odbc-${odbcYear}" | grep -oE "Version [0-9]+\.[0-9]+\.[0-9]+" | head -1 | awk '{print $2}')
	fi
	downloadURL="https://sfc-repo.snowflakecomputing.com/odbc/macuniversal/${appNewVersion}/snowflake_odbc_mac_64universal-${appNewVersion}.dmg"
	;;
