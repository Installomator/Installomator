googlewebdesigner)
    name="Google Web Designer"
    type="dmg"
    downloadURL="https://dl.google.com/webdesigner/mac/shell/googlewebdesigner_mac.dmg"
    appNewVersion=$(curl -fs https://support.google.com/webdesigner/topic/6350071\?hl\=en | tr '<' '\n' |  grep -o "Shell Build.*$" | grep -o "[0-9].*[0-9]" | sort --version-sort | tail -1)
    expectedTeamID="EQHXZ8M8AV"
    ;;
