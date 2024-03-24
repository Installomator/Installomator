pritunl)
    name="Pritunl"
    type="pkgInZip"
    packageID="com.pritunl.pkg.Pritunl"
    archiveName="Pritunl.pkg.zip"
    downloadURL=$(downloadURLFromGit pritunl pritunl-client-electron)
    appNewVersion=$(versionFromGit pritunl pritunl-client-electron)
    expectedTeamID="U22BLATN63"
    ;;
