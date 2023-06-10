citrixworkspace)
    #credit: Erik Stam (@erikstam) and #Philipp on MacAdmins Slack
    name="Citrix Workspace"
    type="pkgInDmg"
    parseURL() {
        urlToParse='https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html#ctx-dl-eula-external'
        htmlDocument=$(curl -s -L $urlToParse)
        xmllint --html --xpath "string(//a[contains(@rel, 'downloads.citrix.com')]/@rel)" 2> /dev/null <(print $htmlDocument)
    }
    downloadURL="https:$(parseURL)"
    newVersionString() {
        urlToParse='https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html'
        htmlDocument=$(curl -fs $urlToParse)
        xmllint --html --xpath 'string(//p[contains(., "Version")])' 2> /dev/null <(print $htmlDocument)
    }
    appNewVersion=$(newVersionString | cut -d ' ' -f2 )
    versionKey="CitrixVersionString"
    expectedTeamID="S272Y5R93J"
    ;;
