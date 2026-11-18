gpgsuite)
    # credit: Micah Lee (@micahflee)
    name="GPG Suite"
    type="pkgInDmg"
    pkgName="Install.pkg"
    # gpgtools.com currently only publishes nightly builds (path moved under
    # /nightlies/), so match the GPG_Suite dmg regardless of path.
    downloadURL=$(curl -s https://gpgtools.com/ | grep -oE 'https://releases\.gpgtools\.com/[^"]*GPG_Suite-[^"]*\.dmg' | head -1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*GPG_Suite-(.*)\.dmg/\1/')
    expectedTeamID="PKV8ZPD836"
    blockingProcesses=( "GPG Keychain" )
    # the dmg filename carries the build number, which is CFBundleVersion in
    # version.plist (CFBundleShortVersionString is "2026.1 (<commit>)")
    appCustomVersion(){ defaults read /Library/Application\ Support/GPGTools/version.plist CFBundleVersion }
    ;;
