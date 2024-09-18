eposconnect)
    name="EPOS Connect"
    type="pkg"
    #packageID="com.DSEA.pkg.DSEASDKM1"
    #downloadURL="https://www.eposaudio.com/globalassets/___image-library/_enterprise/files/english/epos-connect/epos-connect-7.7.0/eposconnect_7.7.0.44457.pkg"
    downloadURL=$(curl -fs "https://www.eposaudio.com/en/dk/software/epos-connect" | tr '"' "\n" | grep -o "^https://www.eposaudio.*.pkg$")
    versionKey="CFBundleVersion"
    # 2024-02-06: appNewVersion commented out as the latest version is 7.8.1 but above page only shows 7.7.0
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*_([0-9.]*).pkg/\1/' | cut -d "." -f4)
    expectedTeamID="8956A7Y69J"
    ;;
