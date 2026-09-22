globalprotect64)
    name="GlobalProtect"
    type="pkg"
    globalProtectBranch="6.4"
    globalProtectBranchPattern='6\.4'
    globalProtectBucketURL="https://pan-gp-client.s3.amazonaws.com"
    appNewVersion="$(
        curl -fsL --connect-timeout 20 --max-time 120 --retry 3 \
            "${globalProtectBucketURL}/?list-type=2&prefix=${globalProtectBranch}." \
            | grep -Eo "<Key>${globalProtectBranchPattern}\\.[0-9]+-[^/<]+/GlobalProtect\\.pkg</Key>" \
            | sed -E 's#^<Key>##; s#/GlobalProtect\.pkg</Key>$##' \
            | awk -F '[-.]' '
                {
                    build = $4
                    sub(/^[^0-9]*/, "", build)
                    if (build ~ /^[0-9]+$/) {
                        printf "%010d\t%010d\t%s\n", $3 + 0, build + 0, $0
                    }
                }
              ' \
            | sort -r \
            | awk -F '\t' 'NR == 1 { print $3 }'
    )"
    [[ -n "$appNewVersion" ]] || cleanupAndExit 14 "Unable to determine the latest GlobalProtect ${globalProtectBranch}.x package."
    downloadURL="${globalProtectBucketURL}/${appNewVersion}/GlobalProtect.pkg"
    expectedTeamID="PXPZ95SK77"
    blockingProcesses=( NONE )
    ;;
