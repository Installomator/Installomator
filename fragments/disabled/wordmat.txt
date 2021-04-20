
wordmat)
   # WordMat currently not signed
   # credit: Søren Theilgaard (@theilgaard)
   name="WordMat"
   type="pkg"
   packageID="com.eduap.pkg.WordMat"
   downloadURL=$(downloadURLFromGit Eduap-com WordMat)
   #downloadURL=$(curl -fs "https://api.github.com/repos/Eduap-com/WordMat/releases/latest" | awk -F '"' "/browser_download_url/ && /pkg/ && ! /sig/ && ! /CLI/ && ! /sha256/ { print \$4 }")
   appNewVersion=$(versionFromGit Eduap-com WordMat)
   #curl -fs "https://api.github.com/repos/Eduap-com/WordMat/releases/latest" | grep tag_name | cut -d '"' -f 4 | sed 's/[^0-9\.]//g'
   expectedTeamID=""
   ;;
