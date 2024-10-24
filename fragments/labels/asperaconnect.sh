asperaconnect)
    name="Aspera Connect"
    type="pkg"
    downloadURL="https://d3gcli72yxqn2z.cloudfront.net/downloads/connect/latest/bin/$(curl -fs 'https://www.ibm.com/support/fixcentral/swg/selectFixes?parent=ibm~Other%20software&product=ibm/Other+software/IBM+Aspera+Connect' --data-raw 'showStatus=false' | egrep -o "ibm-aspera-connect_[0-9.]+_macOS" | head -n1)_x86_64.pkg"
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*ibm-aspera-connect_([0-9]+(\.[0-9]+)*)_macOS.*\.pkg/\1/')
    expectedTeamID="PETKK2G752"
    ;;
