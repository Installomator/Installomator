beamstudio)
    name="Beam Studio"
    type="dmg"
    expectedTeamID="4Y92JWKV94"
    downloadURL="$( curl -s "https://id.flux3dp.com/api/check-update?key=beamstudio-stable" | tr '"' '\n' | grep -m1 dmg )"
    appNewVersion="$( echo "$downloadURL" | cut -d '+' -f 3 | cut -d '.' -f 1-3 )"
    ;;
