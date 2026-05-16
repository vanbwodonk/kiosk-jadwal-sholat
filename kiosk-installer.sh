#!/bin/bash

# be new
apt-get update

# get software
apt-get install \
    unclutter \
    xorg \
    chromium \
    openbox \
    lightdm \
    locales \
    -y

# dir
mkdir -p /home/kiosk/.config/openbox

# create group
groupadd -f kiosk

# create user if not exists
id -u kiosk &>/dev/null || useradd -m kiosk -g kiosk -s /bin/bash 

# rights
chown -R kiosk:kiosk /home/kiosk

# remove virtual consoles
#if [ -e "/etc/X11/xorg.conf" ]; then
#  mv /etc/X11/xorg.conf /etc/X11/xorg.conf.backup
#fi
#cat > /etc/X11/xorg.conf << EOF
#Section "ServerFlags"
#    Option "DontVTSwitch" "true"
#EndSection
#EOF

# create .xprofile to disable sleep screen
if [ -e "/home/kiosk/.xprofile" ]; then
  mv /home/kiosk/.xprofile /home/kiosk/.xprofile.backup
fi
cat > /home/kiosk/.xprofile << EOF
#!/bin/sh
xset s off
xset -dpms
xset s noblank
xset dpms 0 0 0
EOF

chmod +x /home/kiosk/.xprofile

# create config
if [ -e "/etc/lightdm/lightdm.conf" ]; then
  mv /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.backup
fi
cat > /etc/lightdm/lightdm.conf << EOF
[Seat:*]
xserver-command=X -nocursor -nolisten tcp -s 0 -dpms
autologin-user=kiosk
autologin-session=openbox
EOF

# create autostart
if [ -e "/home/kiosk/.config/openbox/autostart" ]; then
  mv /home/kiosk/.config/openbox/autostart /home/kiosk/.config/openbox/autostart.backup
fi
cat > /home/kiosk/.config/openbox/autostart << EOF
#!/bin/bash

#need git clone https://github.com/vanbwodonk/kiosk-jadwal-sholat.git
KIOSK_URL="/home/kiosk/kiosk-jadwal-sholat/index.html"

unclutter -idle 0.1 -grab -root &

while :
do
  xrandr --auto
  chromium \
    --noerrdialogs \
    --no-memcheck \
    --no-first-run \
    --start-maximized \
    --disable \
    --disable-translate \
    --disable-infobars \
    --disable-suggestions-service \
    --disable-save-password-bubble \
    --disable-session-crashed-bubble \
    --incognito \
    --use-gl=egl \
    --enable-gpu-rasterization \
    --enable-zero-copy \
    --ignore-gpu-blocklist \
    --kiosk $KIOSK_URL
  sleep 3600
done &
EOF

echo "Done!"
