cursor)
    name="Cursor"
    type="dmg"
    downloadURL="https://anysphere-binaries.s3.us-east-1.amazonaws.com/production/be4f0962469499f009005e66867c8402202ff0b7/darwin/arm64/Cursor-darwin-arm64.dmg"
    appNewVersion="getJSONValue "$(curl -fs 'https://api2.cursor.sh/updates/api/update/darwin-universal/cursor/0.10.10/')" "name""
    expectedTeamID="VDXQ22DGB9"
    blockingProcesses=( "Cursor" )
    ;;
