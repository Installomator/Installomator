elan)
    elanVersion="$(curl -fs https://archive.mpi.nl/tla/elan/download | grep -o -m2 "ELAN_*.*_mac.dmg" | sed -n '1p' | cut -d "_" -f2)"
    appNewVersion="${elanVersion:0:1}.${elanVersion:2:1}"
    expectedTeamID="P7N398ZW7F"
    name="ELAN_${appNewVersion}"
    type="dmg"
    if [[ "$(arch)" == "arm64" ]]; then
        archiveName="ELAN_$(elanVersion)_M1_mac.dmg"
        downloadURL=https://www.mpi.nl/tools/elan/ELAN_${elanVersion}_M1_mac.dmg
    else
        archiveName="ELAN_$(elanVersion)_mac.dmg"
        downloadURL=https://www.mpi.nl/tools/elan/ELAN_${elanVersion}_mac.dmg
    fi
    ;;
