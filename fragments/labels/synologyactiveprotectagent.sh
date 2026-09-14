synologyactiveprotectagent)
    name="ActiveProtect Agent"
    type="pkg"
    releaseURL="https://archive.synology.com/download/Utility/ActiveProtectAgent"
    releaseVersion=$(curl -fsL "$releaseURL/" | xmllint --html --xpath 'string((//a[contains(@href, "/download/Utility/ActiveProtectAgent/")])[1])' - 2>/dev/null)
    appNewVersion="${releaseVersion##*-}"
    downloadURL=$(curl -fsL "$releaseURL/$releaseVersion" | xmllint --html --xpath 'string((//a[contains(@href, "/Mac/") and substring(@href, string-length(@href) - 3) = ".pkg"])[1]/@href)' - 2>/dev/null)
    versionKey="CFBundleVersion"
    expectedTeamID="X85BAK35Y4"
    ;;
