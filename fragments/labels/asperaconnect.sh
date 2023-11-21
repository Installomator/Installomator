asperaconnect)
    name="$(curl -fS 'https://www.ibm.com/support/fixcentral/swg/selectFixes?parent=ibm~Other%20software&product=ibm/Other+software/IBM+Aspera+Connect' --data-raw 'showStatus=false' | egrep -o "ibm-aspera-connect_[0-9.]+_macOS_x86_64" | head -n1)"
    type="pkg"
    downloadURL="https://d3gcli72yxqn2z.cloudfront.net/downloads/connect/latest/bin/${name}.pkg"
    appNewVersion=$(echo "${name}" | sed -E 's/.*_([0-9.]*)_mac.*/\1/')
    expectedTeamID="RJ747GSBCT"
    ;;
