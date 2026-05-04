blackmagicdesktopvideo)
    name="Blackmagic Desktop Video"
    appName="Blackmagic Desktop Video/Desktop Video Setup.app"
    type="pkgInDmgInZip"
    downloadURL=$(curl --compressed --location --header "Content-Type: application/json;charset=UTF-8" --header "User-Agent: Mozilla/5.0" --data '{"country": "us", "platform": "Mac OS X", "product": "Converters"}' "$(curl -fs https://www.blackmagicdesign.com/api/support/us/downloads.json | /usr/bin/osascript -l 'JavaScript' \
 	    -e "let json = $.NSString.alloc.initWithDataEncoding($.NSFileHandle.fileHandleWithStandardInput.readDataToEndOfFile$(/usr/bin/uname -r | /usr/bin/awk -F '.' '($1 > 18) { print "AndReturnError(ObjC.wrap())" }'), $.NSUTF8StringEncoding)" \
 		-e 'if ($.NSFileManager.defaultManager.fileExistsAtPath(json)) json = $.NSString.stringWithContentsOfFileEncodingError(json, $.NSUTF8StringEncoding, ObjC.wrap())' \
 		-e 'parsed = JSON.parse(json.js)' \
        -e "update = parsed.downloads.filter((download) => download.name.match(/^Desktop Video/))[0]" \
        -e 'download_id = update.urls["Mac OS X"][0].downloadId' \
 	    -e '"https://www.blackmagicdesign.com/api/register/us/download/" + download_id')")
    appNewVersion=$(echo ${downloadURL} | grep -oE '/v([0-9.]+)' | cut -d'v' -f2)
    blockingProcesses=( BlackmagicDesktopVideoSetup LiveKey )
    expectedTeamID="9ZGFBWLSYP"
    ;;
