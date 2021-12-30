pritunl)
    name="Pritunl"
    type="pkgInZip"
    packageID="com.pritunl.pkg.Pritunl"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="Pritunl.arm64.pkg.zip"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="Pritunl.pkg.zip"
    fi
    downloadURL=$(downloadURLFromGit pritunl pritunl-client-electron)
    appNewVersion=$(versionFromGit pritunl pritunl-client-electron)
    expectedTeamID="U22BLATN63"
    ;;
