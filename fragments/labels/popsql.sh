popsql)
     name="PopSQL"
     type="dmg"
     appNewVersion=$(curl -s 'https://popsql-releases.s3.amazonaws.com/mac/latest-mac.yml' | grep version: | cut -d' ' -f2)
     curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" )
     downloadURL="https://get.popsql.com/"
     expectedTeamID="4TFVQY839W"
     ;;
