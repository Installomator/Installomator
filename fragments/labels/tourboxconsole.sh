tourboxconsole)
    name="Tourbox Console"
    type="pkgInZip"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://cdn.tourboxtech.com/prod/console/TourBoxInstall5.12.1_arm64_261023115108.zip"
    else
        downloadURL="https://cdn.tourboxtech.com/prod/console/TourBoxInstall5.12.1_intel_261023115231.zip"
    fi
    appNewVersion=$(echo "$downloadURL" | sed -nE 's|.*/TourBoxInstall([0-9]+\.[0-9]+\.[0-9]+)_.*|\1|p')
    expectedTeamID="8B253ZL4W9"
    ;;
