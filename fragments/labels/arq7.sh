arq7)
    name="Arq7"
    type="pkg"
    packageID="com.haystacksoftware.Arq"
    downloadURL="https://arqbackup.com/download/arqbackup/Arq7.pkg"
    appNewVersion="$(curl -fs "https://arqbackup.com" | grep -io "version .*[0-9.]*.* for macOS" | cut -d ">" -f2 | cut -d "<" -f1)"
    expectedTeamID="48ZCSDVL96"
    ;;
