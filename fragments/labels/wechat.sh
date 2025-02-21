wechat)
    name="WeChat"
    type="dmg"
    downloadURL="https://dldir1.qq.com/weixin/mac/WeChatMac.dmg"
    appNewVersion=$(curl -fsL 'https://dldir1.qq.com/weixin/mac/mac-release.xml' | xpath 'string(//rss/channel/item[1]/title)' 2>/dev/null)
    expectedTeamID="5A4RE8SF68"
    ;;
