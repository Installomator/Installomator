mailmate)
    # info: It is now recommended for new users to use the latest beta release of MailMate instead of the public release, see https://freron.com/download/
    name="MailMate"
    type="tbz"
    versionKey="CFBundleVersion"
    downloadURL="https://updates.mailmate-app.com/archives/MailMateBeta.tbz"
    appNewVersion="$(curl -fs https://updates.mailmate-app.com/beta_release_notes | grep Revision | head -n 1 | sed -E 's/.* ([0-9\.]*) .*/\1/g')"
    expectedTeamID="VP8UL4YCJC"
    ;;
