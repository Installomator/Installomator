wechat)
    name="WeChat"
    type="dmg"
    appNewVersion=$(curl -fsL 'https://dldir1.qq.com/weixin/mac/mac-release.xml' | grep -o '<sparkle:shortVersionString>[^<]*' | head -1 | cut -d'>' -f2)
    downloadURL=$(curl -fsL 'https://dldir1.qq.com/weixin/mac/mac-release.xml' | grep '<enclosure' | head -1 | grep -o 'url="[^"]*"' | cut -d'"' -f2)
    expectedTeamID="5A4RE8SF68"
    ;;
