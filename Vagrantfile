# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 512
    vb.cpus = 1
  end

  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  #   if ! [ -L /var/www ]; then
  #     rm -rf /var/www
  #     ln -fs /vagrant /var/www
  #   fi
  # SHELL

  config.vm.synced_folder "salt/roots/", "/srv/salt"

  config.vm.provision :salt do |salt|
    salt.masterless = true
    salt.minion_config = "salt/minion"
    salt.run_highstate = true
  end

  (1..3).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.provision "shell", inline: <<-SHELL
        echo "node-#{i}" | sudo tee /etc/hostname
        sudo hostname node-#{i}
        echo "Node #{i} provisioned..."
      SHELL
    end
  end
end
