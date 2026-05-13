#!/bin/sh

setup_opkg() {
    echo "Copying /opt to /log/0/hd/opt for persistence..."
    mkdir -p /log/0/hd/opt
    cp -a /opt/* /log/0/hd/opt/
    echo "Overriding /opt with a bind mount to /log/0/hd/opt..."
    mount --bind /log/0/hd/opt /opt

    wget https://bin.entware.net/armv7sf-k3.2/installer/generic.sh -O /tmp/entware-setup-generic.sh
    chmod +x /tmp/entware-setup-generic.sh
    /tmp/entware-setup-generic.sh
}

redo_opt() {
    echo "Overriding /opt with a bind mount to /log/0/hd/opt..."
    mount --bind /log/0/hd/opt /opt
}

if [ ! -f "/log/0/.firstboot_complete" ] && [ $1 = "init"]; then
    setup_opkg
    touch /log/0/.firstboot_complete
    echo "Firstboot setup complete."
else
    redo_opt
fi