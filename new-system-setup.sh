# Enable RPM Fusion
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
     https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# Enable OpenH264 repo
sudo dnf config-manager --set-enabled fedora-cisco-openh264

# Google Drive support
sudo dnf copr enable sergiomb/google-drive-ocamlfuse

# Add VS Code repo
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Update the system
sudo dnf update -y

# Fix for slow startups with Intel SSDs
sudo systemctl mask systemd-udev-settle

# Install commonly used packages
sudo dnf install -y kdiff3 thunderbird pidgin quassel-client the_silver_searcher git git-cola python3-pyside  \
    python3-speedtest-cli vim-enhanced postgresql-server compat-ffmpeg28 libreoffice-calc libreoffice-writer \
    akmod-nvidia xorg-x11-drv-nvidia-cuda dkms acpid ffmpeg-libs libatomic mc pidgin gstreamer1-libav \
    gstreamer1-vaapi gstreamer1-plugins-{good,good-extras,ugly} gstreamer1-plugin-openh264 mozilla-openh264 jq \
    gitk hplip hplip-gui youtube-dl mscore restic kaccounts-providers vlc code gimp google-drive-ocamlfuse \
    snapd vim-enhanced thunderbird quassel-client pidgin \
    https://prerelease.keybase.io/keybase_amd64.rpm \
    https://downloads.slack-edge.com/linux_releases/slack-4.3.2-0.1.fc21.x86_64.rpm \
    http://download.sourcegear.com/DiffMerge/4.2.0/diffmerge-4.2.0.697.stable-1.x86_64.rpm

# Broken? ktp-accounts-kcm

#sdkman
curl -s "https://get.sdkman.io" | bash &&  source "$HOME/.sdkman/bin/sdkman-init.sh"
for P in java maven gradle micronaut jbake ; do 
    sdk install $P 
done


# Android emulator acceleration support
sudo dnf group install --with-optional virtualization -y
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

# idrive
cd ~/Downloads
wget https://www.idrivedownloads.com/downloads/linux/download-for-linux/IDriveForLinux.zip
mkdir -p ~/local/idrive/bin
mkdir -p ~/local/idrive/var/restore
unzip IDriveForLinux.zip
mv IDriveForLinux/scripts/* ~/local/idrive/bin/
chmod +x ~/local/idrive/bin/*pl

# Jetbrains Toolbox
cd ~/Downloads
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.16.6207.tar.gz
tar xzf jetbrains-toolbox*
mkdir -p ~/local/bin
mv jetbrains-toolbox-1.16.6207/jetbrains-toolbox ~/local/bin/
rm -rf jetbrains-toolbox-1.16.6207

# Flyway
wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/6.1.2/flyway-commandline-6.1.2-linux-x64.tar.gz | tar xvz && sudo ln -s `pwd`/flyway-6.1.2/flyway /usr/local/bin 

# DBeaver
wget https://dbeaver.io/files/dbeaver-ce-latest-linux.gtk.x86_64.tar.gz
tar xf dbeaver-ce-latest-linux.gtk.x86_64.tar.gz
mv dbeaver ~/local/
rm dbeaver-ce-latest-linux.gtk.x86_64.tar.gz

# Bitwarden
wget "https://vault.bitwarden.com/download/?app=desktop&platform=linux" -O ~/local/bin/bitwarden
chmod +x ~/local/bin/bitwarden

