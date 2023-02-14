r)
    name="R"
    type="pkg"
    downloadURL="https://cloud.r-project.org/bin/macosx/$( curl -fsL https://cloud.r-project.org/bin/macosx/ | grep -m 1 -o '<a href=".*pkg">' | sed -E 's/.+"(.+)".+/\1/g' )"
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    expectedTeamID="VZLD955F6P"
    ;;
