suitestudio)
    name="Suite"
    type="pkg"
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://saturn-installer-prd-124359286071-bucket.s3.amazonaws.com/suite-installer-osx-arm64.pkg"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://saturn-installer-prd-124359286071-bucket.s3.amazonaws.com/suite-installer-osx-x64.pkg"
    fi
    expectedTeamID="58KZ58VMJ8"
    ;;
