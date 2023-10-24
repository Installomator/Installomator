isadora)
    name="Isadora"
    type="pkgInDmg"
    packageID="com.troikatronix.isadora-fat-std-installer"
    expectedTeamID="Q5V96MD6S6"
    siteURL="https://troikatronix.com"
    downloadURL="$siteURL/$(curl -s "$siteURL/get-it/" | tr '"' '\n' | grep -m1 dmg)"
    # This will have issues if they go past 9 in any part of the version, but hopefully
    #   by then they might have provided a better way to collect the current version.
    URLversion="$( echo "$downloadURL" | cut -d '-' -f 2 | cut -d 'f' -f 1 )"
    appNewVersion="${URLversion[1]}.${URLversion[2]}.${URLversion[3]}"
    ;;
