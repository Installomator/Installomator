grooveomnidialerenterpriseedition)
	name="Groove Omnidialer Enterprise Edition"
	type="zip"
	appNewVersion=$( curl -fs 'https://groove-dialer.s3.us-west-2.amazonaws.com/electron/enterprise/latest-mac.yml' | grep ^version: | cut -c 10-21 ) 
	downloadURL="https://groove-dialer.s3.us-west-2.amazonaws.com/electron/enterprise/Groove+OmniDialer+Enterprise+Edition-"$appNewVersion"-universal-mac.zip" 
	expectedTeamID="ZDYDJ5XPF3"
;;
