gimpdev)
    name="GIMP"
    type="dmg"
    gimpDetails="$(curl -fs "https://www.gimp.org/gimp_versions.json")"
    appNewVersion="$(getJSONValue "$gimpDetails" "DEVELOPMENT[0].version")"
    dlVersion="$(echo "${appNewVersion}" | cut -d'.' -f1-2)"
    [[ "$(getJSONValue "$gimpDetails" "DEVELOPMENT[0].macos[0].filename")" == *"x86_64"* ]] && gimpDmgx86_64="$(getJSONValue "$gimpDetails" "DEVELOPMENT[0].macos[0].filename")" && gimpDmgArm64="$(getJSONValue "$gimpDetails" "DEVELOPMENT[0].macos[1].filename")"
    [[ "$(getJSONValue "$gimpDetails" "DEVELOPMENT[0].macos[0].filename")" == *"arm64"* ]] && gimpDmgArm64="$(getJSONValue "$gimpDetails" "DEVELOPMENT[0].macos[0].filename")" && gimpDmgx86_64="$(getJSONValue "$gimpDetails" "DEVELOPMENT[0].macos[1].filename")"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.gimp.org/gimp/v${dlVersion}/macos/${gimpDmgArm64}"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.gimp.org/gimp/v${dlVersion}/macos/${gimpDmgx86_64}"
    fi
    expectedTeamID="T25BQ8HSJF"
    ;;
