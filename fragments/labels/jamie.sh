jamie)
    name="Jamie v5"
    type="dmg"
    appNewVersion=$(git ls-remote --tags --sort='-v:refname' "https://github.com/meetjamie/releases.git" | grep -o "refs/tags/app-v[^{}]*" | sed 's/refs\/tags\/app-v//' | grep -vEi "beta|preview" | sort -V | tail -n 1)
    downloadURL="https://github.com/meetjamie/releases/releases/download/app-v${appNewVersion}/Jamie.v5_${appNewVersion}_universal.dmg"
    expectedTeamID="88YHHX72GQ"
    ;;
