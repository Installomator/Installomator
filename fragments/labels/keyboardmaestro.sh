keyboardmaestro)
    # credit: Søren Theilgaard (@theilgaard)
    name="Keyboard Maestro"
    type="zip"
    downloadURL="https://download.keyboardmaestro.com/"
    #appNewVersion=$( curl -fs https://www.stairways.com/press/ | grep -i "releases Keyboard Maestro" | head -1 | sed -E 's/.*releases Keyboard Maestro ([0-9.]*)<.*/\1/g' ) # Text based from web site
    appNewVersion=$( curl -fs "https://www.stairways.com/press/rss.xml" | xpath '//rss/channel/item/title[contains(text(), "releases Keyboard Maestro")]' 2>/dev/null | head -1 | sed -E 's/.*releases Keyboard Maestro ([0-9.]*)<.*/\1/g' ) # uses XML, so might be a little more precise/future proof
    expectedTeamID="QMHRBA4LGH"
    blockingProcesses=( "Keyboard Maestro Engine" "Keyboard Maestro" )
    ;;
