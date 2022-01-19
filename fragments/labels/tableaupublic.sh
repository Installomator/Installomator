tableaupublic)
    name="Tableau Public"
    type="pkgInDmg"
    packageID="com.tableausoftware.tableaudesktop"
    downloadURL=$(curl -fs https://www.tableau.com/downloads/public/mac | awk '/TableauPublic/' | xmllint --recover --html --xpath "//a/text()" -)
    appNewVersion=$(/usr/bin/python -c "import re; url = '$downloadURL'; ver_regex = re.compile(r'([0-9]+(?:-[0-9]+)+)'); ver_regex.findall(url); dashes = ''.join(ver_regex.findall(url)); print(dashes.replace('-', '.'))")
    expectedTeamID="QJ4XPRK37C"
    ;;
