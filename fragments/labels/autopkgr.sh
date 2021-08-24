autopkgr)
    # credit: Søren Theilgaard (@theilgaard)
    name="AutoPkgr"
    type="dmg"
    #downloadURL=$(curl -fs "https://api.github.com/repos/lindegroup/autopkgr/releases/latest" | awk -F '"' "/browser_download_url/ && /dmg/ && ! /sig/ && ! /CLI/ && ! /sha256/ { print \$4 }")
    downloadURL=$(downloadURLFromGit lindegroup autopkgr)
    appNewVersion=$(versionFromGit lindegroup autopkgr)
    expectedTeamID="JVY2ZR6SEF"
    ;;
