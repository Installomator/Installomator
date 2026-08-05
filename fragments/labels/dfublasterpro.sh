dfublasterpro)
    name="DFU Blaster Pro"
    type="pkgInDmg"
    packageID="com.twocanoes.pkg.DFU-Blaster"
    downloadURL="https://twocanoes-software-updates.s3.amazonaws.com/DFU_Blaster_Pro.dmg"
    appNewVersion=$(curl -fs "https://twocanoes.com/products/mac/dfu-blaster/history/" | grep -A1 "<h3>Change Log</h3>" | sed -n 's/.*<h4>Version \(.*\) Build \(.*\)<\/h4>.*/\1.\2/p')
    expectedTeamID="UXP6YEHSPW"
    ;;
