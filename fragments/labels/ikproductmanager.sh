ikproductmanager)
    name="IK Product Manager"
    type="pkgInDmg"
    curlOptions=( -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" -H "Referer: https://www.ikmultimedia.com/" -H "Sec-Fetch-Dest: document" )
    appNewVersion=$(curl -s 'https://www.ikmultimedia.com/am2/?' -H 'Host: www.ikmultimedia.com'| grep client_latest_version | cut -d\" -f2 | head -1)
    downloadURL="https://g1.ikmultimedia.com/plugins/ProductManager/ik_product_manager_${appNewVersion}.dmg"
    expectedTeamID="S78FW55573"
    ;;
