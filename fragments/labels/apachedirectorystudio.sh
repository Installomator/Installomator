apachedirectorystudio)
    name="ApacheDirectoryStudio"
    type="dmg"
    downloadURL=$( curl -fs https://directory.apache.org/studio/download/download-macosx.html | grep -o 'http[^"]*downloads[^"]*ApacheDirectoryStudio[^"]*.dmg' | head -1 )
    appNewVersion=$( curl -fs $downloadURL | grep -o 'studio/\([^/]*\)/ApacheDirectoryStudio' | cut -d'/' -f2 )
    versionKey="CFBundleVersion"
    appName="$name.app"
    archiveName="$name.$type"
    blockingProcesses=( $name )
    expectedTeamID="2GLGAFWEQD"
    ;;