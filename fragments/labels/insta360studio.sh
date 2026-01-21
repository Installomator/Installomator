insta360studio|\
insta360)
    # credit: Tully Jagoe
    name="Insta360 Studio"
    type="pkg"
    pkgName=$(curl -fs -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15" "https://www.insta360.com/download/hot-download" | sed -n 's/.*\(Insta360Studio_.*\.pkg\).*/\1/p')
    appNewVersion=$(curl -fs -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15" "https://www.insta360.com/download/hot-download" | sed -n 's/.*Insta360Studio_\([0-9.]*\)_release_insta360.*/\1/p')
    versionKey="CFBundleShortVersionString"
    downloadURL=$(curl -fs -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15" "https://www.insta360.com/download/hot-download" | sed -n 's/.*\(https:\/\/.*\.pkg\).*/\1/p')
    expectedTeamID="UBX9CH9GDX"
    ;;
