sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf config-manager --set-enabled fedora-cisco-openh264

sudo dnf update 

sudo systemctl mask systemd-udev-settle

sudo dnf install kdiff3 thunderbird pidgin quassel-client the_silver_searcher git git-cola python3-pyside  \
    python3-speedtest-cli vim-enhanced postgresql-server compat-ffmpeg28 \
    libreoffice-calc libreoffice-writer akmod-nvidia xorg-x11-drv-nvidia-cuda dkms acpid \
    ffmpeg-libs libatomic mc pidgin gstreamer1-libav gstreamer1-vaapi gstreamer1-plugins-{good,good-extras,ugly} \
    gstreamer1-plugin-openh264 mozilla-openh264 

curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
for P in java maven gradle micronaut ; do sdk install $P ; done


    #~/Downloads/slack-4.2.0-0.1.fc21.x86_64.rpm \
    #~/Downloads/google-chrome-stable_current_x86_64.rpm ~/Downloads/pencil-3.1.0.ga-1.x86_64.rpm 

#    1  sudo dnf install \*-firmware
#    2  sudo dnf install alsa-firmware alsa-tools-firmware uhd-firmware b43-firmware broadcom-bt-firmware dvb-firmware r5u87x-firmware
#   25  sudo dnf install rpmfusion-free-release-tainted
#   26  sudo dnf install libdvdcss
#   27  sudo dnf install rpmfusion-nonfree-release-tainted
#   28  sudo dnf install \*-firmware
#   63  dnf install akmod-nvidia
#   90  dnf install hplip
#  147  dnf install vdpauinfo libva-vdpau-driver libva-utils
#  161  dnf install xorg-x11-drv-nvidia-cuda-libs
#  169  dnf install "kernel-devel == $(uname -r)"
#  179  history | grep dnf install > pkgs.sh
#  180  history | grep "dnf install" > pkgs.sh
