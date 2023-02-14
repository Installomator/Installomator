golang)
    name="GoLang"
    type="pkg"
    packageID="org.golang.go"
    downloadURL="https://go.dev$(curl -fs "https://go.dev/dl/" | grep -i "downloadBox" | grep "pkg" | tr '"' '\n' | grep "pkg")"
    appNewVersion="$( echo "${downloadURL}" | sed -E 's/.*\/(go[0-9.]*)\..*/\1/g' )" # Version includes letters "go" in the beginning
    expectedTeamID="EQHXZ8M8AV"
    blockingProcesses=( NONE )
    ;;
