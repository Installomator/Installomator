synologyactivebackupforbusinessagent)
    name="Synology Active Backup for Business Agent"
    type="pkgInDmg"
    packageID="com.synology.activebackup-agent"
    versionKey="CFBundleVersion"
    downloadURL=$(appVersion=`curl -sf https://archive.synology.com/download/Utility/ActiveBackupBusinessAgent | grep -m 1 /download/Utility/ActiveBackupBusinessAgent/ | sed "s|.*>\(.*\)<.*|\\1|"` && appShortVersion=`sed 's#.*-\(\)#\1#' <<< $appVersion` && echo https://global.download.synology.com/download/Utility/ActiveBackupBusinessAgent/"$appVersion"/Mac/x86_64/Synology%20Active%20Backup%20for%20Business%20Agent-"$appVersion".dmg)
    # appNewVersion=$(appVersionP1=`curl -sf https://archive.synology.com/download/Utility/ActiveBackupBusinessAgent | grep -m 1 /download/Utility/ActiveBackupBusinessAgent/ | sed "s|.*>\(.*\)-.*|\\1|"` && sed 's/\(.\{0\}\)./\17/' <<< $appVersionP1)
    appNewVersion=$(curl -sf https://archive.synology.com/download/Utility/ActiveBackupBusinessAgent | grep -m 1 /download/Utility/ActiveBackupBusinessAgent/ | sed "s|.*>\(.*\)<.*|\\1|" | sed "s#.*-\(\)#\1#")
    expectedTeamID="X85BAK35Y4"
    ;;
