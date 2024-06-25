mkuser)
    name="mkuser"
    type="pkg"
    packageID="org.freegeek.pkg.mkuser"
    downloadURL="$(downloadURLFromGit freegeek-pdx mkuser)"
    # appNewVersion="$(versionFromGit freegeek-pdx mkuser unfiltered)"
    # mkuser does not adhere to numbers and dots only for version numbers.
    # Pull request submitted to add an unfiltered option to versionFromGit
    appNewVersion="$(osascript -l 'JavaScript' -e 'run = argv => JSON.parse(argv[0]).tag_name' -- "$(curl -m 5 -sfL 'https://update.mkuser.sh' 2> /dev/null)" 2> /dev/null)"
    appCustomVersion(){
        if [ -e /usr/local/bin/mkuser ]; then
            awk -F " |=|'" '($2 == "MKUSER_VERSION") { print $(NF-1); exit }' /usr/local/bin/mkuser
        fi
    }
    expectedTeamID="YRW6NUGA63"
    ;;
