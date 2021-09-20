#!/bin/bash
### Written by Jing Hao 21 September 2021 ###
### For easy user creation ###
# Please place a .pub file containing the target user's public key in the same directory as this script
# Param 1 = target username, Param 2 (Optional) = target password
if ! [ -z "$1" ]; then
    pubfile=$(find . -maxdepth 1 -name '*.pub');
    echo $pubfile;
    if ! [ -z "$pubfile" ]; then
        sudo adduser --disabled-password --gecos "$1,,,," $1;
        if ! [ -z "$2" ]; then
            sudo chpasswd <<<"$1:$2";
        else
            echo "No password set";
        fi
        sudo mkdir /home/$1/.ssh;
        sudo cp $pubfile /home/$1/.ssh/authorized_keys;
        rm $pubfile
        sudo chown -R $1:$1 /home/$1/.ssh;
        sudo chmod 700 /home/$1/.ssh;
        sudo chmod 400 /home/$1/.ssh/authorized_keys;
        #sudo usermod -aG sudo $1;
        #sudo groupadd docker;
        sudo usermod -aG docker $1;
        sudo usermod -aG $1 $USER;
        sudo newgrp $1;
        echo "Public IP Address for this machine is $(curl ifconfig.co)";
    else
        echo "Place a publickey ending with .pub extension in the current directory";
    fi
else
    echo "Please enter a name as the first param";
fi