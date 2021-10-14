firefox_da)
    name="Firefox"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=firefox-latest&amp;os=osx&amp;lang=da"
    appNewVersion=$(/usr/bin/curl https://www.mozilla.org/en-US/firefox/releases/ --silent | /usr/bin/grep '<html' | /usr/bin/awk -F\" '{ print $8 }') # Credit: William Smith (@meck)
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;
