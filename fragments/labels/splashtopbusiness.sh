splashtopbusiness)
    name="Splashtop Business"
    type="pkgInDmg"
    splashtopbusinessVersions=$(curl -fsL "https://www.splashtop.com/wp-content/themes/responsive/downloadx.php?product=stb&platform=mac-client")
    downloadURL=$(curl -Ls -w %{url_effective} -o /dev/null $(getJSONValue "$splashtopbusinessVersions" "url"))
    appNewVersion="${${downloadURL#*INSTALLER_v}%*.dmg}"
    expectedTeamID="CPQQ3AW49Y"
    ;;
