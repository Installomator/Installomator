insta360studio)
    name="Insta360 Studio"
    type="pkgInZip"
    downloadURL=$(curl -fsL "https://openapi.insta360.com/app/appDownload/getGroupApp?group=insta360-x5&X-Language=en-us" | grep -oE 'https://[a-z]+\.insta360\.com/[a-z]+/[0-9a-f]+/Insta360(%20|_)Studio_[0-9.]+_release_[^"]*_signed[^"]*\.zip' | sed -E 's/^(.*Studio_)([0-9.]+)(_release.*)$/\2 \1\2\3/' | sort -k1,1V | tail -1 | cut -d' ' -f2)
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*Studio_([0-9.]+)_release.*/\1/')
    expectedTeamID="847R5ZLN8S"
    ;;
