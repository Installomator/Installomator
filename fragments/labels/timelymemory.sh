timelymemory)
    name="Memory"
    type="zip"
    archiveName="memory.app.zip"
    downloadURL="https://memory.timelyapp.com/download/mac"
    appNewVersion="$(curl -fsIL https://memory.timelyapp.com/download/mac | grep -i ^location | cut -d "/" -f6)"
    expectedTeamID="NGR7G7F269"
    ;;