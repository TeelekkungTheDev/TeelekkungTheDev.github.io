#!/bin/bash
if [ $(uname) = "Darwin" ]; then
	if [ $(uname -p) = "arm" ] || [ $(uname -p) = "arm64" ]; then
		echo "It's recommended this script be ran on macOS/Linux with a clean iOS device running checkra1n attached"
		read -p "Press enter to continue"
		ARM=yes
	fi
fi

echo "odysseyra1n deployment script"
echo "(C) 2020, CoolStar. All Rights Reserved"
echo "(C) 2020, Sahakiyat. Just modify to only work in iOS 14 and fix ssh I have problem"

echo ""
echo "Before you begin: This script is only work in iOS 14 don't try other"
echo "If you use Linux I don't confirm it's going to work (ssh part) might try in near feature(longggggggggggggggg)"
echo "If you're already jailbroken, you can run this script on the checkra1n device."
echo "If you'd rather start clean, please Reset System via the Loader app first."
read -p "Press enter to continue"

if ! which curl >> /dev/null; then
	echo "Error: curl not found"
	exit 1
fi
if [[ "${ARM}" = yes ]]; then
	if ! which zsh >> /dev/null; then
		echo "Error: zsh not found"
		exit 1
	fi
else
	if which iproxy >> /dev/null; then
		iproxy 4444 44 >> /dev/null 2>/dev/null &
	else
		echo "Error: iproxy not found"
		exit 1
	fi
fi
rm -rf odyssey-tmp
mkdir odyssey-tmp
cd odyssey-tmp

echo '#!/bin/zsh' > odyssey-device-deploy.sh
if [[ ! "${ARM}" = yes ]]; then
	echo 'cd /var/root' >> odyssey-device-deploy.sh
fi

echo "Downloading Resources..."
curl -L -O https://github.com/coolstar/odyssey-bootstrap/raw/master/bootstrap_1700.tar.gz -O https://github.com/coolstar/odyssey-bootstrap/raw/master/org.coolstar.sileo_2.0.0b6_iphoneos-arm.deb -O https://raw.githubusercontent.com/TeelekkungTheDev/repo/master/odyssey-device-deploy.sh
clear

echo "Copying Files to your device"
echo "Default password is: alpine"
scp -P4444 bootstrap_1700.tar.gz migration org.coolstar.sileo_2.0.0b6_iphoneos-arm.deb odyssey-device-deploy.sh root@localhost:/var/root/
	clear

echo "Installing Procursus bootstrap and Sileo on your device"
echo "Default password is: alpine"
ssh -p4444 root@localhost "zsh /var/root/odyssey-device-deploy.sh"
echo "All Done!"
killall iproxy