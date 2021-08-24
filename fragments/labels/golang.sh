golang)
    # credit: Søren Theilgaard (@theilgaard)
    name="GoLang"
    type="pkg"
    packageID="org.golang.go"
    downloadURL="$(curl -fsIL "https://golang.org$(curl -fs "https://golang.org/dl/" | grep -i "downloadBox" | grep "pkg" | tr '"' '\n' | grep "pkg")" | grep -i "^location" | awk '{print $2}' | tr -d '\r\n')"
    appNewVersion="$( echo "${downloadURL}" | sed -E 's/.*\/(go[0-9.]*)\..*/\1/g' )" # Version includes letters "go"
    expectedTeamID="EQHXZ8M8AV"
    blockingProcesses=( NONE )
    ;;
