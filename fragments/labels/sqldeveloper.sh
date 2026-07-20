sqldeveloper|\
oraclesqldeveloper)
    # This label does not support killing blocking processes
    # The name of the process that needs to be killed is 'java'. Killing that may have unintended consequences.
    name="SQLDeveloper"
    type="zip"
    if [[ "$(arch)" == "i386" ]]; then
        cleanupAndExit 33 "Oracle SQL Developer is not longer available for x64 architecture" ERROR
    fi
    downloadURL=$(curl -fs https://www.oracle.com/database/sqldeveloper/technologies/download/ | grep -o 'https://download\.oracle\.com/otn_software/java/sqldeveloper/sqldeveloper-[0-9\.]*-macos-aarch64\.app\.zip')
    # CFBundleShortVersionString does not exist. CFBundleVersion gives 4 dot-separated numbers. The custom version gives 5 numbers and matches the version in downloadURL.
    appNewVersion=$(echo "$downloadURL" | awk -F - '{print $2}')
    versionKey="CFBundleVersion"
    appCustomVersion() {
        sql_version_file="/Applications/SQLDeveloper.app/Contents/Resources/sqldeveloper/sqldeveloper/bin/version.properties"
        [[ -f "${sql_version_file}" ]] && /usr/bin/grep VER_FULL "${sql_version_file}" | /usr/bin/cut -d = -f 2
    }
    expectedTeamID="VB5E2TV963"
    ;;
