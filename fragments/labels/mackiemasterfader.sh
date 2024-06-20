masterfader)
#credit: @sintichn macadmins slack
name="MasterFader"
type="dmg"
appNewVersion="$(curl -sf https://mackie.com/en/products/mixers/master-fader/master_fader.html | grep -m 1 "macOS" | sed -n 's/.*Fader \([0-9]\)\.\([0-9]\).*/\1_\2_/p')"
downloadURL="https://mackie.com/img/file_resources/Master_Fader_v"$appNewVersion"Setup.dmg"
expectedTeamID="6X5AC85L48"
;;
