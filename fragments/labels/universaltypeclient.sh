universaltypeclient)
    name="Universal Type Client"
    type="pkgInZip"
    downloadURL=https://bin.extensis.com/$( curl -fs https://www.extensis.com/support/universal-type-server-7/ | grep -o "UTC-[0-9].*M.zip" )
    appNewVersion=$(echo "$downloadURL" | awk -F'UTC-' '{split($2, a, "-M"); print a[1]}' | tr '-' '.')
    expectedTeamID="J6MMHGD9D6"
    ;;
