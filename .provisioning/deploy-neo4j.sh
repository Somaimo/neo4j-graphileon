#!/usr/bin/env bash

# This script is expected to be run as root through sudo for example.

# Download neo4j requirements
apt install -y openjdk-8-jre

echo "Passoword $GRAPHYNEO4JPASS"

# Prepare neo4j installation
wget -O - https://debian.neo4j.org/neotechnology.gpg.key | sudo apt-key add -
echo 'deb https://debian.neo4j.org/repo stable/' | tee /etc/apt/sources.list.d/neo4j.list
apt-get update

# install neo4j
apt-get -y install neo4j

# Configure neo4j to listen to any ip address assigned to the vm
sed -i 's/#dbms.connectors.default_listen_address=0.0.0.0/dbms.connectors.default_listen_address=0.0.0.0/g' /etc/neo4j/neo4j.conf



# start neo4j and enable at system boot
systemctl enable neo4j
systemctl restart neo4j

#sleep for 20 seconds to give neo4j time to boot
sleep 20

# change default password for neo4j user.
echo -e "CALL dbms.changePassword('"$NEO4JADMINPASS"');\n" | cypher-shell -u neo4j -p neo4j

# add new user to neo4j for a bit more security, just a little bit
echo -e "CALL dbms.security.createUser('graphy','"$GRAPHYNEO4JPASS"',false);\n" | cypher-shell -u neo4j -p $NEO4JADMINPASS

# all done