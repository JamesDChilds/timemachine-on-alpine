#TODO: Use getopts to make this a little more flexable

user=$1
if [ -z $user ] 
then
        printf "Please pass a username as only argument\n"
        exit 1
fi

mkdir -p /backups/timemachine
addgroup timemachine
chown root:timemachine /backups/timemachine
chmod 0770 /backups/timemachine

#TODO: Check if user already exists

adduser $user -G timemachine

apk update

# TODO: Check these services are already installed

apk add dbus
apk add avahi
apk add netatalk
rc-update add dbus
rc-update add avahi-daemon
rc-update add netatalk

cp /etc/afp.conf /etc/afp.conf.bak
echo "[Global]

[TimeMachine]
path = /backups/timemachine
time machine = yes
valid users = @timemachine
" > /etc/afp.conf

/etc/init.d/dbus start
/etc/init.d/avahi-daemon start
/etc/init.d/netatalk start
