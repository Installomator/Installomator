synologyactiveprotectagent)
    name="Synology ActiveProtect Agent"
    type="pkg"
    packageID="com.synology.activeprotect.pkg"
    versionKey="CFBundleVersion"
    appCustomVersion(){ pkgutil --pkg-info-plist com.synology.activeprotect.pkg 2>/dev/null | grep -A1 pkg-version | tail -1 | sed -E 's/.*<string>.*-([0-9]+)<\/string>.*/\1/'; }
    downloadURL=$(appVersion=`curl -sf https://archive.synology.com/download/Utility/ActiveProtectAgent | grep -m 1 /download/Utility/ActiveProtectAgent/ | sed "s|.*>\(.*\)<.*|\\1|"` && appShortVersion=`sed 's#.*-\(\)#\1#' <<< $appVersion` && echo https://global.download.synology.com/download/Utility/ActiveProtectAgent/"$appVersion"/Mac/x86_64/Synology%20ActiveProtect%20Agent-"$appVersion".pkg)
    # downloadURL=$(appVersion=`curl -sf https://archive.synology.com/download/Utility/ActiveProtectAgent | grep -m 1 /download/Utility/ActiveProtectAgent/ | sed "s|.*>\(.*\)<.*|\\1|"` && appShortVersion=`sed 's#.*-\(\)#\1#' <<< $appVersion` && echo https://global.synologydownload.com/download/Utility/ActiveProtectAgent/"$appVersion"/Mac/x86_64/Synology%20ActiveProtect%20Agent-"$appVersion".pkg)
    appNewVersion=$(curl -sf https://archive.synology.com/download/Utility/ActiveProtectAgent | grep -m 1 /download/Utility/ActiveProtectAgent/ | sed "s|.*>\(.*\)<.*|\\1|" | sed "s#.*-\(\)#\1#")
    expectedTeamID="X85BAK35Y4"
    blockingProcesses=( ActiveProtect Agent Service )
    ;;
