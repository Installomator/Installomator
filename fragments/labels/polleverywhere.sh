polleverywhere)
    name="Poll Everywhere"
    type="dmg"
    appNewVersion=$(curl -fsL https://www.polleverywhere.com/app/releases/mac | grep h3 --max-count 1 | awk '{ gsub(/<\/?h3>/, ""); print }')
    downloadURL="https://polleverywhere-app.s3.amazonaws.com/mac-stable/$appNewVersion/pollev.dmg"
    expectedTeamID="W48F3X5M8W"
    versionKey="CFBundleVersion"
    ;;
