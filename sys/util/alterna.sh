#!/bin/sh

DEFAULT_PKG="dropbear curl"

setup_opkg() {
    wget https://bin.entware.net/armv7sf-k3.2/installer/generic.sh -O /tmp/entware-setup-generic.sh
    chmod +x /tmp/entware-setup-generic.sh
    /tmp/entware-setup-generic.sh
    for i in $DEFAULT_PKG; do
        /opt/bin/opkg install $i # we do this to avoid the issue of 1 bad package taking down the rest
    done
    chmod +x /opt/etcinit.d/rc.unslung
    /opt/etc/init.d/rc.unslung start
}

redo_opt() {
    echo "Overriding /opt with a bind mount to /log/0/hd/opt..."
    mount --bind /log/0/hd/opt /opt
}

start_telnet() {
    busybox telnetd &
    echo "Telnet started. Avoid using telnet, as ssh is now possible."
}

sys_configure() {
    if [ -f "/opt/etc/passwd" ]; then 
        cp /opt/etc/passwd /etc/passwd
    fi
    ln -s /opt/root/.ssh /root/.ssh

}

if [ ! -f "/log/0/.firstboot_complete" ] && [ $1 = "init" ]; then
    echo "Firstboot incomplete - defaulting to firstboot setup."
    echo "Setting up package management..."
    setup_opkg

    echo "Starting telnet..."
    start_telnet

    touch /log/0/.firstboot_complete
    echo "Firstboot setup complete."
fi

if [ "$1" = "passwd" ]; then
    if [ ! "$2" = "" ]; then
        PWD=$(mkpasswd -m md5 $2)
        echo "root:$PWD:0:0::/root:/bin/sh" > /opt/etc/passwd
        ln -s /opt/etc/passwd /etc/passwd
    else
        echo "Provide a password!"
    fi
fi