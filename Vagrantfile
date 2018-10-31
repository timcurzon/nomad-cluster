# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 512
    vb.cpus = 1
  end

  # config.vm.network "public_network"

  config.vm.synced_folder "salt/roots/", "/srv/salt"
  config.vm.synced_folder "salt/pillar/", "/srv/pillar"

  (1..1).each do |i|
    config.vm.define "node-#{i}" do |node|

      node.vm.hostname = "node-#{i}" # Salt minion will use this for ID

      node.vm.network "private_network", ip: "172.16.0.#{i}" # Frontend network
      node.vm.network "private_network", ip: "172.30.0.#{i}" # Backend network

      node.vm.provision :salt do |salt|
        salt.masterless = true
        salt.minion_config = "salt/minion"
        salt.run_highstate = true
      end

    end
  end
end
