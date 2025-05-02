sqldeveloper|\
oraclesqldeveloper)
    # This label does not support killing blocking processes
    # The name of the process that needs to be killed is 'java'. Killing that may have unintended consequences.
    name="SQLDeveloper"
    type="zip"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL=$(curl -fs https://www.oracle.com/database/sqldeveloper/technologies/download/ | grep -oE "download.oracle.com.*macos-aarch64.app.zip")
    else
        downloadURL=$(curl -fs https://www.oracle.com/database/sqldeveloper/technologies/download/ | grep -oE "download.oracle.com.*macos-x64.app.zip")
    fi
    downloadURL="https://${downloadURL}"
    # CFBundleShortVersionString does not exist. CFBundleVersion gives 4 dot-separated numbers. The custom version gives 5 numbers and matches the version in downloadURL.
    appNewVersion=$(echo "$downloadURL" | awk -F - '{print $2}')
    versionKey="CFBundleVersion"
    appCustomVersion() {
        sql_version_file="/Applications/SQLDeveloper.app/Contents/Resources/sqldeveloper/sqldeveloper/bin/version.properties"
        if [[ -f "${sql_version_file}" ]]; then
            /usr/bin/grep VER_FULL "${sql_version_file}" | /usr/bin/cut -d = -f 2
        fi
    }
    expectedTeamID="VB5E2TV963"
    ;;
