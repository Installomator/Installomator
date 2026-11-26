jabradirect)
    name="Jabra Direct"
    type="pkgInDmg"
    versionKey="CFBundleVersion"
    jabraJSON=$(curl -fs "https://jabraexpressonlinejdo.jabra.com/jdo/jdo.json")
    downloadURL=$(getJSONValue "$jabraJSON" "MacDownload")
    appNewVersion=$(getJSONValue "$jabraJSON" "MacVersion")
    expectedTeamID="55LV32M29R"
    ;;
