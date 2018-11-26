# -*- mode: ruby -*-
# vim: ft=ruby


# ---- Custom settings ----
# Change the name of the Graphileon debian file to the correct file stored in .provisioning
GRAPHILEONFILE     = "Graphileon-2.0.0-beta.0.deb"

# Passwords for neo4j users
NEO4JADMINPASS = "marc"
GRAPHYNEO4JPASS = "graphy"

# ---- Configuration variables ----

GUI               = false # Enable/Disable GUI
RAM               = 512   # Default memory size in MB

# Network configuration
DOMAIN            = ".nat.test.lan"
NETWORK           = "192.168.50."
NETMASK           = "255.255.255.0"

# Default Virtualbox .box
BOX               = 'ubuntu/bionic64'


HOSTS = {
   "neo4j-app" => [NETWORK+"10", RAM, GUI, BOX],
   "neo4j-data" => [NETWORK+"11", RAM, GUI, BOX]
}

# Variant with graphileon running in a separate VM with a Desktop Environment.
# This is not really functional because Graphileon cannot be run headless.
# HOSTS = {
#    "neo4j-app" => [NETWORK+"10", RAM, GUI, BOX],
#    "neo4j-data" => [NETWORK+"11", RAM, GUI, BOX],
#    # "graphileon" => [NETWORK+"12", RAM, GUI, "peru/ubuntu-18.04-desktop-amd64"]
# }

# ---- Vagrant configuration ----

Vagrant.configure(2) do |config|
  HOSTS.each do | (name, cfg) |
    ipaddr, ram, gui, box = cfg

    config.vm.define name do |machine|
      machine.vm.box   = box
      if name["graphileon"]
        config.vm.box_version = "20181101.01"
      end
      machine.vm.guest = :ubuntu

      machine.vm.provider "virtualbox" do |vbox|
        vbox.gui    = gui
        vbox.memory = ram
        vbox.name = name
      end

      machine.vm.hostname = name + DOMAIN
      machine.vm.network 'private_network', ip: ipaddr, netmask: NETMASK

      if name["neo4j"]
        machine.vm.provision "shell", path: ".provisioning/deploy-neo4j.sh",
        env:{"NEO4JADMINPASS" => NEO4JADMINPASS, "GRAPHYNEO4JPASS" => GRAPHYNEO4JPASS},
        privileged: true
      end
  
      if name["graphileon"]
        graphileon_filepath = ".provisioning" + GRAPHILEONFILE
        if File.exists?(graphileon_filepath)
          machine.vm.provision "file", source: graphileon_filepath, destination: "/tmp/Graphileon.deb"
          machine.vm.provision "shell", path: ".provisioning/deploy-graphileon.sh"
        end
      end
    end
  end # HOSTS-each
end
