korgsoftwarepass)
    name="Korg Software Pass"
    type="pkgInDmg"
    packageID="jp.co.korg.pkg.korgsoftwarepass"
    downloadVersion="$(curl -fs "https://id.korg.com/static_pages/3" | grep -E ".KORG_Software_Pass_([0-9]+(_[0-9]+)+)\.dmg" | cut -d\" -f4 | cut -d_ -f5-7 | cut -d. -f1 | xargs)"
    appNewVersion="$(echo "$downloadVersion" | tr '_' '.')"
    downloadURL="https://storage.korg.com/korgms/korg_collection/mac/KORG_Software_Pass_${downloadVersion}.dmg"
    expectedTeamID="9H3HFX7NG2"
    ;;
