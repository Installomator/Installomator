vonagebusiness)
    # @BigMacAdmin (Second Son Consulting) with assists from @Isaac, @Bilal, and @Theilgaard
    name="Vonage Business"
    type="dmg"
    downloadURL="https://vbc-downloads.vonage.com/mac/VonageBusinessSetup.dmg"
    expectedTeamID="E37FZSUGQP"
    archiveName="VonageBusinessSetup.dmg"
    curlOptions=( -L -O --compressed )
    appNewVersion=$(curl -fs "https://s3.amazonaws.com/vbcdesktop.vonage.com/prod/mac/latest-mac.yml" | grep -i version | cut -w -f2)
    ;;
