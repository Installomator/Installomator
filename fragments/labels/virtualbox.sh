virtualbox)
    # credit: AP Orlebeke (@apizz)
    name="VirtualBox"
    type="pkgInDmg"
    pkgName="VirtualBox.pkg"
    downloadURL="https:$(curl -fsL "https://www.oracle.com/virtualization/technologies/vm/downloads/virtualbox-downloads.html" | grep "OSX.dmg" | xmllint --html --xpath 'string(//a/@href)' -)"
    appNewVersion=$(echo "${downloadURL}" | awk -F '/' '{print $5}')
    expectedTeamID="VB5E2TV963"
    ;;
