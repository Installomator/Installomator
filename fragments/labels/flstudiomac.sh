flstudiomac)
    name="flstudiomac"
    type="pkgInDmg"
    packageID="com.Image-Line.pkg.flcloud.plugins
com.Image-Line.pkg.24ONLINE"
    downloadURL="https://support.image-line.com/redirect/flstudio_mac_installer"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Safari/605.1.15" )
    appNewVersion=$(curl -fsL "https://support.image-line.com/api.php?call=get_version_info&callback=il_get_version_info_cb&prod_type=undefined" | \
        sed 's/var get_version_info_res;get_version_info_res = il_get_version_info_cb(//;s/);$//' | \
        sed 's/\\//g' | \
        grep -o '"os":"mac","version":"[0-9.]*"' | \
        sed 's/.*"version":"\([0-9.]*\)".*/\1/')
    expectedTeamID="N68WEP5ZZZ"
    ;;
    
