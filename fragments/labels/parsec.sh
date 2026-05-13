parsec)
    name="Parsec"
    type="pkg"
    downloadURL="https://builds.parsecgaming.com/package/parsec-macos.pkg"
    appNewVersion=$(curl -fsL https://parsec.app/changelog.xml | xmllint -xpath '//*[local-name()="build"]/text()' - | grep -oE '\d+-\d+$' | head -1 | sed -r 's/([0-9]+)-([0-9]+)/\1.\2.0/')
    expectedTeamID="Y9MY52XZDB"
    ;;
