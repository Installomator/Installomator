#!/bin/zsh

# buildInstallomatorPkg.sh

# this script will create a pkg installer that places the Installomator.sh
# script file in /usr/local/Installomator/Installomator.sh

# this is for use with MDM systems that require the tools to be local

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

pkgname="Installomator"
version="0.6"
identifier="com.scriptingosx.${pkgname}"
install_location="/usr/local/Installomator/"
signature="Developer ID Installer: Armin Briegel (JME5BW3F3R)"
dev_team="JME5BW3F3R" # asc-provider
dev_account="developer@scriptingosx.com"
dev_keychain_label="notary-scriptingosx"


scriptfolder=$(dirname "$0")
projectfolder=$(mktemp -d)
payloadfolder="${projectfolder}/payload"


# MARK: main code starts here

# create a projectfolder with a payload folder
if [[ ! -d "${payloadfolder}" ]]; then
    mkdir -p "${payloadfolder}"
fi

# copy the script file
cp ${scriptfolder}/Installomator.sh ${payloadfolder}
chmod 755 ${payloadfolder}/Installomator.sh

# set the DEBUG variable to 0
sed -i '' -e 's/^DEBUG=1$/DEBUG=0/g' ${payloadfolder}/Installomator.sh

# build the component package
pkgpath="${scriptfolder}/${pkgname}.pkg"

pkgbuild --root "${projectfolder}/payload" \
         --identifier "${identifier}" \
         --version "${version}" \
         --install-location "${install_location}" \
         "${pkgpath}"

# build the product archive

productpath="${scriptfolder}/${pkgname}-${version}.pkg"

productbuild --package "${pkgpath}" \
             --version "${version}" \
             --identifier "${identifier}" \
             --sign "${signature}" \
             "${productpath}"

# clean up project folder
rm -Rf "${projectfolder}"

# NOTE: notarytool requires Xcode 13

# upload for notarization
xcrun notarytool submit "$productpath" --keychain-profile "$dev_keychain_label" --wait

# staple result
echo "## Stapling $productpath"
xcrun stapler staple "$productpath"

exit 0
