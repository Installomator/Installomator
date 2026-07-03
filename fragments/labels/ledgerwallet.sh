ledgerwallet)
    name="Ledger Wallet"
    type="dmg"
    downloadURL="https://download.live.ledger.com/latest/mac?c=1"
    appNewVersion=$(curl -fs "https://download.live.ledger.com/latest-mac.yml" | grep "^version:" | sed 's/version: //')
    expectedTeamID="X6LFS5BQKN"
    ;;
