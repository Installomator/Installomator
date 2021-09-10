universaltypeclient)
    name="Universal Type Client"
    type="pkgInZip"
    #packageID="com.extensis.UniversalTypeClient.universalTypeClient70.Info.pkg" # Does not contain the real version of the download
    downloadURL=https://bin.extensis.com/$( curl -fs https://www.extensis.com/support/universal-type-server-7/ | grep -o "UTC-[0-9].*M.zip" )
    expectedTeamID="J6MMHGD9D6"
    ;;
