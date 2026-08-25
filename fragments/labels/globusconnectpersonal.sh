globusconnectpersonal)
    name="Globus Connect Personal"
    type="dmg"
    downloadURL="https://downloads.globus.org/globus-connect-personal/mac/stable/globusconnectpersonal-latest.dmg"
    appNewVersion="$(curl -fsL "https://downloads.globus.org/globus-connect-personal/mac/stable/personal-changelog.html" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
    expectedTeamID="WYQ7U7YUC9"
    ;;
