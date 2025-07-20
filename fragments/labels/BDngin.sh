dbngin)
    name="DBngin"
    type="dmg"
    appNewVersion=$(curl -fs https://dbngin.com/blog/2018/09/changelogs.html | grep -o "Build [0-9]*" | head -1 | cut -d' ' -f2)
    downloadURL="https://files.dbngin.com/macos/${appNewVersion}/DBngin.dmg"
    expectedTeamID="3X57WP8E8V"
    blockingProcesses=( "DBngin" )
