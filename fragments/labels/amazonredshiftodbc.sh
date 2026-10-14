amazonredshiftodbcdriver)
    name="Amazon Redshift ODBC Driver"
    type="pkg"
    expectedTeamID="94KV3E626L"
    downloadURL=$(curl -fsL https://docs.aws.amazon.com/redshift/latest/mgmt/odbc20-install-mac.html | grep -oE 'https://s3.amazonaws.com/redshift-downloads/drivers/odbc/[0-9\.]+/AmazonRedshiftODBC-64-bit[0-9\.]+universal\.pkg')
    appNewVersion=$(echo $downloadURL | sed -E 's#^.*/([0-9\.]+)/.*#\1#')
    packageID="com.amazon.redshift.odbc2x64"
;;
