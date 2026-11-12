ibmdatashift)
    name="IBM Data Shift"
    type="zip"
    downloadURL="$(downloadURLFromGit IBM mac-ibm-migration-tool)"
    appNewVersion="$(echo "$downloadURL" | sed -nE 's|.*/v-([0-9]+\.[0-9]+\.[0-9]+)-b-[0-9]+/.*|\1|p')"
    expectedTeamID="PETKK2G752"
    archiveName="IBM.Data.Shift.zip"
    ;;
