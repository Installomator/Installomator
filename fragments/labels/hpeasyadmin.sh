hpeasyadmin)
    name="HP Easy Admin"
    type="zip"
    versionKey="CFBundleShortVersionString"
    #relies on Home brew since HP never publishes or advertises version number
    appNewVersion=$( curl -fsL https://formulae.brew.sh/cask/hp-easy-admin | perl -0777 -ne 'print "$1\n" if /Current version:\s*<a[^>]*>([^,<]+)/s' )
    downloadURL="https://ftp.hp.com/pub/softlib/software12/HP_Quick_Start/osx/Applications/HP_Easy_Admin.app.zip"
    expectedTeamID="6HB5Y2QTA3"
    ;;
