r)
    name="R"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://cloud.r-project.org/bin/macosx/$( curl -fsL https://cloud.r-project.org/bin/macosx/ | grep -m 1 -o '<a href=".*arm64\.pkg">' | sed -E 's/.+"(.+)".+/\1/g' )"
        appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)-.*\..*/\1/g')
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://cloud.r-project.org/bin/macosx/$( curl -fsL https://cloud.r-project.org/bin/macosx/ | grep -o '<a href=".*pkg">' | grep -m 1 -v "arm64" | sed -E 's/.+"(.+)".+/\1/g' )"
        appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    fi
    expectedTeamID="VZLD955F6P"
    appCustomVersion() { defaults read /Applications/r.app/Contents/Info.plist CFBundleShortVersionString | awk '{print $2}' }
    ;;
