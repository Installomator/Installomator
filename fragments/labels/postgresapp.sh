postgresapp)
	#  A full-featured PostgreSQL installation for macOS that includes PostGIS, a user-friendly interface, a convenient menu bar item, and automatic updates
    name="Postgres"
    type="dmg"
    downloadURL=$(downloadURLFromGit PostgresApp PostgresApp)
    appNewVersion=$(versionFromGit PostgresApp PostgresApp)
    archiveName="Postgres-$appNewVersion.dmg"
    expectedTeamID="ZF84SJ5A3G"
    ;;
