glyphs3)
    name="Glyphs 3"
    type="zip"
    downloadURL="https://updates.glyphsapp.com/latest3.php"
    appNewVersion=$(curl -fsIL $downloadURL | sed -nE 's/content-disp.*Glyphs([^-]*).*/\1/p')
    versionKey="CFBundleShortVersionString"
    expectedTeamID="X2L8375ZQ7"
    ;;
