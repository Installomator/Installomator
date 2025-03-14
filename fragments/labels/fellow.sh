fellow)
    name="Fellow"
    type="dmg"
    downloadURL="https://fellow.app/desktop/download/darwin/latest/"
    appNewVersion="$(curl -fsIL "${downloadURL}" | grep -i ^location | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/' | head -1)"
    expectedTeamID="2NF46HY8D8"
    ;;
