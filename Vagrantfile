# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 512
    vb.cpus = 1
  end

  config.vm.synced_folder "salt/roots/", "/srv/salt"
  config.vm.synced_folder "salt/pillar/", "/srv/pillar"

  (1..1).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.hostname = "node-#{i}" # Minion will use this as ID for now
      node.vm.provision :salt do |salt|
        salt.masterless = true
        # salt.minion_id = "minion-#{i}" # Not working, bug?
        salt.minion_config = "salt/minion"
        salt.run_highstate = true
      end
    end
  end
end
