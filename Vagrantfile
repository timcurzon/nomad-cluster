# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
    vb.cpus = 1
  end

  config.vm.synced_folder "saltstack/salt/", "/srv/salt"
  config.vm.synced_folder "saltstack/pillar/", "/srv/pillar"
  config.vm.synced_folder "containers", "/containers"
  config.vm.synced_folder "services", "/services"

  (1..1).each do |i|
    config.vm.define "node-#{i}" do |node|

      node.vm.hostname = "node-#{i}" # Salt minion will use this for ID

      node.vm.network "private_network", ip: "172.16.0.10#{i}" # Frontend network
      node.vm.network "private_network", ip: "172.30.0.#{i}", virtualbox__intnet: true # Backend network

      # Default route
      #node.vm.provision "shell",
      #  run: "always",
      #  inline: "ip route del default; ip route add default via 10.0.2.2 proto dhcp src 172.16.0.10#{i}"

      node.vm.provision :salt do |salt|
        salt.masterless = true
        salt.minion_config = "saltstack/minion"
        salt.pillar({
          "vault token" => "[[insert root token value here]]"
        })
        salt.run_highstate = true
      end

    end
  end
end
