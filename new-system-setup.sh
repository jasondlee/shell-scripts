# Enable RPM Fusion
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
     https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# Enable OpenH264 repo
sudo dnf config-manager --set-enabled fedora-cisco-openh264

# Add VS Code repo
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Update the system
sudo dnf update 

# Fix for slow startups with Intel SSDs
sudo systemctl mask systemd-udev-settle

# Install commonly used packages
sudo dnf install -y kdiff3 thunderbird pidgin quassel-client the_silver_searcher git git-cola python3-pyside  \
    python3-speedtest-cli vim-enhanced postgresql-server compat-ffmpeg28 \
    libreoffice-calc libreoffice-writer akmod-nvidia xorg-x11-drv-nvidia-cuda dkms acpid \
    ffmpeg-libs libatomic mc pidgin gstreamer1-libav gstreamer1-vaapi gstreamer1-plugins-{good,good-extras,ugly} \
    gstreamer1-plugin-openh264 mozilla-openh264 jq gitk hplip hplip-gui youtube-dl mscore

#sdkman
curl -s "https://get.sdkman.io" | bash &&  source "$HOME/.sdkman/bin/sdkman-init.sh"
for P in java maven gradle micronaut jbake ; do 
    sdk install $P 
done

# Google Drive support
sudo dnf copr enable sergiomb/google-drive-ocamlfuse
sudo dnf install google-drive-ocamlfuse

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
