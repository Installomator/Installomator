snowflakeodbc)
	name="Snowflake ODBC Driver"
	type="pkgInDmg"
	pkgName="snowflakeODBC.pkg"
	packageID="net.snowflake.odbc"
	expectedTeamID="W4NT6CRQ7U"
	odbcRepo="https://sfc-repo.snowflakecomputing.com/odbc/macuniversal"
	appNewVersion=$(curl -fsL "$odbcRepo/" | grep -oE 'href="[0-9]+\.[0-9]+\.[0-9]+/index\.html"' | sed -E 's#href="([0-9]+\.[0-9]+\.[0-9]+)/index\.html"#\1#' | sort -t. -k1,1nr -k2,2nr -k3,3nr | head -n 1)
	downloadURL="$odbcRepo/$appNewVersion/snowflake-odbc-$appNewVersion.universal.dmg"
	;;
