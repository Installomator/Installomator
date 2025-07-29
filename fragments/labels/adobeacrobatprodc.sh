adobeacrobatprodc)
    name="Adobe Acrobat Pro DC"
    appName="Acrobat Distiller.app"
    type="pkgInDmg"
    pkgName="Acrobat/Acrobat DC Installer.pkg"
    packageID="com.adobe.acrobat.DC.viewer.app.pkg.MUI"
    downloadURL="https://trials.adobe.com/AdobeProducts/APRO/Acrobat_HelpX/osx10/Acrobat_DC_Web_WWMUI.dmg"
    releaseNotesURL="https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html"
    appNewVersion=$(curl -s $(curl -s $releaseNotesURL | xmllint --html --xpath 'string(//table//tr[2]//a/@href)' - 2>/dev/null) | grep -m1 '.dmg' | sed -E 's/.*([0-9]{2})([0-9]{3})([0-9]{5}).*/\1.\2.\3/' )
    expectedTeamID="JQ525L2MZD"
    blockingProcesses=( "Acrobat Pro DC" )
    Company="Adobe"
    ;;
