firefox)
    name="Firefox"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US"
    appNewVersion=$(/usr/bin/curl https://www.mozilla.org/en-US/firefox/releases/ --silent | /usr/bin/grep '<html' | /usr/bin/awk -F\" '{ print $8 }') # Credit: William Smith (@meck)
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;
