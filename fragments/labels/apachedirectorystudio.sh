apachedirectorystudio)
    name="ApacheDirectoryStudio"
    type="dmg"
    downloadURL=$( curl -fs https://directory.apache.org/studio/download/download-macosx.html | grep -o 'http[^"]*downloads[^"]*ApacheDirectoryStudio[^"]*.dmg' | head -1 )
    appNewVersion=$( curl -fs https://directory.apache.org/studio/download/download-macosx.html  | grep -o 'studio/\([^/]*\)/ApacheDirectoryStudio' | cut -d'/' -f2 | head -1)
    versionKey="CFBundleVersion"
    expectedTeamID="2GLGAFWEQD"
    ;;
