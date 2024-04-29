networksharemounter)
    name="NetworkShareMounter"
    type="pkg"
    packageID="de.fau.rrze.NetworkShareMounter"
    appNewVersion=$(curl -sfL https://gitlab.rrze.fau.de/api/v4/projects/506/releases | grep -o 'release-[0-9]\+\.[0-9]\+\.[0-9]\+' | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -n 1)
    downloadURL=$(curl -sfL "https://gitlab.rrze.fau.de/api/v4/projects/506/releases/release-$appNewVersion/assets/links/" | grep -Eo '(http|https)://[a-zA-Z0-9./?=_%:-]*.pkg' | head -n 1)
    expectedTeamID="C8F68RFW4L"
    ;;
