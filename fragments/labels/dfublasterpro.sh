dfublasterpro)
    name="DFU Blaster Pro"
    type="pkgInDmg"
    downloadURL="https://twocanoes-software-updates.s3.amazonaws.com/DFU_Blaster_Pro.dmg"
    appNewVersion=$( getJSONValue "$(curl -fsL https://data.twocanoes.com/api/version_info)" "[\"com.twocanoes.DFU-Blaster-Pro\"].version" )
    expectedTeamID="UXP6YEHSPW"
    ;;
