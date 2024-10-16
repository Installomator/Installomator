sawgrassprintutility)
    name="Sawgrass Print Utility"
    type="dmg"
    downloadURL="https://print.sawgrassink.com/SawgrassPrintUtility.dmg"
    appNewVersion=$(curl -fsL https://pm-dist-channel.s3.amazonaws.com/latest-mac.yml | grep "version" | cut -d " " -f 2)
    expectedTeamID="2DD4HMHX5K"
    ;;
