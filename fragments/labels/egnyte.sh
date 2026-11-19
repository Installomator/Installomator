egnyte)
    # credit: #MoeMunyoki from MacAdmins Slack
    name="Egnyte Connect"
    type="pkg"
    appNewVersion=$(curl -fs "https://egnyte-cdn.egnyte.com/egnytedrive/mac/en-us/versions/default.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' | cut -d '"' -f 2)
    downloadURL="https://egnyte-cdn.egnyte.com/egnytedrive/mac/en-us/${appNewVersion}/EgnyteConnectMac.pkg"
    expectedTeamID="FELUD555VC"
    blockingProcesses=( NONE )
    ;;
