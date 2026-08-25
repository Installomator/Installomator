adobeacrobatprodc)
    name="Adobe Acrobat Pro DC"
    appName="Acrobat Distiller.app"
    type="pkgInDmg"
    pkgName="Acrobat/Acrobat DC Installer.pkg"
    packageID="com.adobe.acrobat.DC.viewer.app.pkg.MUI"
    downloadURL="https://trials.adobe.com/AdobeProducts/APRO/Acrobat_HelpX/osx10/Acrobat_DC_Web_WWMUI.dmg"
    releaseNotesURL="https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html"
    appNewVersion=$(curl -sfL "$releaseNotesURL" | grep -m6 "continuous/dccontinuous.*#" | awk '!/Optional update/ { if ($0 ~ /\(Windows Only\)/) next; else if (match($0, /[0-9]+\.[0-9]+\.[0-9]+ *\(Mac\)/)) {v=substr($0,RSTART,RLENGTH); sub(/ *\(Mac\)/,"",v); print v} else if (match($0, /[0-9]+\.[0-9]+\.[0-9]+/)) print substr($0,RSTART,RLENGTH) }' | head -n1)
    expectedTeamID="JQ525L2MZD"
    blockingProcesses=( "Acrobat Pro DC" )
    Company="Adobe"
    ;;
