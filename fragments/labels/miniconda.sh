miniconda)
    type="pkg"
	packageID="io.continuum.pkg.prepare_installation io.continuum.pkg.run_installation io.continuum.pkg.pathupdate"
    if [[ $(arch) == arm64 ]]; then
		name="Miniconda3-latest-MacOSX-arm64"
		downloadURL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.pkg"
	elif [[ $(arch) == i386 ]]; then
		name="Miniconda3-latest-MacOSX-x86_64"
		downloadURL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.pkg"
	fi
    expectedTeamID="Z5788K4JT7"
    ;;
