flstudiomac)
    name="flstudio_mac"
    type="pkgInDmg"
    packageID="com.Image-Line.pkg.FL21.2ONLINE"
    downloadURL="https://install.image-line.com/flstudio/flstudio_mac_21.2.2.3470.dmg"
    appNewVersion="$(getJSONValue $(curl -fsL "https://support.image-line.com/api.php?call=get_version_info&callback=il_get_version") "prod.741.mac.version")"
    expectedTeamID="N68WEP5ZZZ"
    ;;
