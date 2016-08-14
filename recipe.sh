#NOT READY - still in draft mode #####


#!/bin/bash

# Kali Linux ISO recipe for : Hacker Haydn install
#########################################################################################
# Desktop 	: Gnome
# Metapackages	: None
# ISO size 	: XX
# Special notes	: Installs tools
#		: 
# Background	: http://www.offensive-security.com/kali-linux/kali-linux-recipes/
#########################################################################################


### PREPARE FOR LIVE BUILD ###
# Update and install dependencies

apt-get update
apt-get install git live-build cdebootstrap -y

# Clone the default Kali live-build config.

git clone git://git.kali.org/live-build-config.git

# Let's begin our customisations:

cd live-build-config
#######END#####


## SECTION TO ADD APT-GET packages to gnome (full install)
cat <<EOF > ~/live-build-config/kali-config/variant-gnome/package-lists/kali.list.chroot
#screenshots
shutter
#terminal emulator
terminator
EOF
####END###






### DOWNLOAD FILES####
#placing into correct directory

#directory for other packages such as Nessus to have the deb downloaded into
mkdir -p ~/live-build-config/kali-config/variant-light/package-lists/includes.chroot/packages

#Download Nessus into th e packages dir
wget "http://downloads.nessus.org/nessus3dl.php?file=Nessus-6.8.1-debian6_amd64.deb&licence_accept=yes&t=498160e76b486ccb8268b839ac9851d5" -O ~/live-build-config/kali-config/common/includes.chroot/packages/Nessus-6.8.1-debian6_amd64.deb


#To download pycharm
wget -O ~/live-build-config/kali-config/common/includes.chroot/packages/pycharm-community-2016.2.1.tar.gz "https://download.jetbrains.com/python/pycharm-community-2016.2.1.tar.gz"

#To download PTF
git clone https://github.com/trustedsec/ptf.git ~/live-build-config/kali-config/common/includes.chroot/packages/ptf
################################



###SETING UP HOOKS ###

###==Install files===
#
cat <<EOF > ~/live-build-config/kali-config/common/hooks/01-installdebs.binary
dpkg -i ~/live-build-config/kali-config/common/includes.chroot/packages/Nessus-6.8.1-debian6_amd64.deb
#need to extract
#then change dir and install
dpkg  -i ~/live-build-config/kali-config/common/includes.chroot/packages/pycharm-community-2016.2.1.tar.gz
EOF
##===END



#=== PTF SETUP FILE =====

#then edit the config file to exclude all packages
cat <<EOF > ~/live-build-config/kali-config/common/includes.chroot/packages/ptf/config/ptf.config
######################################
# Main PTF Configuration file
######################################
#
### This is the base directory where PTF will install the files
BASE_INSTALL_PATH="/pentest"

### Specify the output log file
LOG_PATH="src/logs/ptf.log"

### When using update_all, also update all of your debian/ubuntu modules
AUTO_UPDATE="ON"

### This will ignore modules and not install them - everything is comma separated and based on name - example: modules/exploitation/metasploit,modules/exploitation/set or entire module categories, like modules/code-audit/*,/modules/reporting/*
IGNORE_THESE_MODULES="/modules/av-bypass/*,/modules/code-audit/*,/modules/exploitation/*,/modules/intelligence-gathering/*,/modules/password-recovery/*,/modules/pre-engagement/*,/modules/reporting/*,/modules/reversing/*,/modules/threat-modeling/*,/modules/vulnerability-analysis/*,/modules/windows-tools/*,/modules/wireless/*,modules/post-exploitation/crackmapexec,modules/post-exploitation/credcrack,modules/post-exploitation/dnscat2,modules/post-exploitation/egressbuster,modules/post-exploitation/ere,modules/post-exploitation/fcrackzip,/modules/post-exploitation/__init__,modules/post-exploitation/install_update_all,modules/post-exploitation/meterssh,modules/post-exploitation/owaspzsc,modules/post-exploitation/pivoter,modules/post-exploitation/poshc2,modules/post-exploitation/powersploit,modules/post-exploitation/pth-toolkit,modules/post-exploitationkek,/modules/post-exploitation/spraywmi,modules/post-exploitation/unicorn"
EOF

#install PTF
cd ~/live-build-config/kali-config/common/includes.chroot/packages/ptf/ --update-all
./ptf --update-all

#######END####


#need to add a preseed file

