citrixworkspace)
    name="Citrix Workspace"
    type="pkgInDmg"
    pkgName="Install Citrix Workspace.pkg"
    curlOptions=( --user-agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36" )
    citrixWorkspaceData=$(curl -fsL "https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html" "${curlOptions[@]}")
    downloadURL="https:$(xmllint --html --xpath "string(//a[contains(@class, 'ctx-dl-link')]/@rel)" 2>/dev/null <(print "$citrixWorkspaceData"))"
    appNewVersion=$(xmllint --html --xpath "string(//div[@class='ctx-dl-content']/p[starts-with(., 'Version')])" 2>/dev/null <(print "$citrixWorkspaceData") | sed -nE 's/.*Version[[:space:]]+([0-9.]+).*/\1/p')
    versionKey="CitrixVersionString"
    expectedTeamID="S272Y5R93J"
    ;;
