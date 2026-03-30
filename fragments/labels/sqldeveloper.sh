sqldeveloper|\
oraclesqldeveloper)
    # This label does not support killing blocking processes
    # The name of the process that needs to be killed is 'java'. Killing that may have unintended consequences.
    name="SQLDeveloper"
    type="zip"
    downloadURL=$(curl -fs https://www.oracle.com/database/sqldeveloper/technologies/download/ | grep -o 'https://download\.oracle\.com[^"]*macos-x64\.app\.zip')
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL=$(echo "$downloadURL" | sed 's/x64/aarch64/')
    fi
    # CFBundleShortVersionString does not exist. CFBundleVersion gives 4 dot-separated numbers. The custom version gives 5 numbers and matches the version in downloadURL.
    appNewVersion=$(echo "$downloadURL" | awk -F - '{print $2}')
    versionKey="CFBundleVersion"
    appCustomVersion() {
        sql_version_file="/Applications/SQLDeveloper.app/Contents/Resources/sqldeveloper/sqldeveloper/bin/version.properties"
        [[ -f "${sql_version_file}" ]] && /usr/bin/grep VER_FULL "${sql_version_file}" | /usr/bin/cut -d = -f 2
    }
    expectedTeamID="VB5E2TV963"
    ;;
