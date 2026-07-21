sqldeveloper|\
oraclesqldeveloper)
    # This label does not support killing blocking processes
    # The name of the process that needs to be killed is 'java'. Killing that may have unintended consequences.
    name="SQLDeveloper"
    type="zip"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL=$(curl -fsL https://www.oracle.com/database/sqldeveloper/technologies/download/ | grep -Eo 'https://download\.oracle\.com/otn_software/java/sqldeveloper/sqldeveloper-[0-9\.]*-macos-aarch64\.app\.zip' | head -1)
    else
        printlog "Oracle SQL Developer is only available for Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "Oracle SQL Developer requires Apple Silicon" ERROR
    fi
    # CFBundleShortVersionString does not exist. CFBundleVersion gives 4 dot-separated numbers. The 5 dot-separated version number form the downloadURL is truncated to be comparable with CFBundleVersion.
    versionKey="CFBundleVersion"
    appNewVersion=$(echo "$downloadURL" | awk -F - '{print $2}' | cut -d . -f 1-4)
    expectedTeamID="VB5E2TV963"
    blockingProcesses=( NONE )
    ;;
