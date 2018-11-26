#!/usr/bin/env bash

# install graphileon for the first time (this is a bug of graphileon on ubuntu 18.04)
retries=0
function installGraphileon {
    retries=$((retries + 1))
    if (( retries > 3)); 
    then
        echo "installation either finished or failed for a second time. exiting from graphileon install."
        return 0
    fi
    sudo dpkg --install /tmp/Graphileon-2.0.0-beta.0.deb
    if [ $? != 0 ];
    then
        echo "error encounter while installing Graphileon, will try to fix and reinstall it."
        sudo apt-get update
        sudo apt install --fix-broken -y
        installGraphileon
    else
        echo "installation successfull."
    fi
}

installGraphileon

# putting Graphileon as a Startupitem
# sudo /opt/Graphileon/Graphileon &
echo "finished installing graphileon."
