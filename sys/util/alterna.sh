#!/bin/sh

setRndHostname() {
    ID=$(hexdump -n 3 -e '"%06X\n"' /dev/urandom)
    NAME="hyperdiver-$ID"
    echo "Setting hostname to $NAME"
    echo $NAME > /etc/hostname
}

setRndHostname