# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

configure_ne = true
# Increase numworkers if you want more than 3 nodes
numworkers = 2

# VirtualBox settings
# Increase vmmemory if you want more than 512mb memory in the vm's
vmmemory = 1024
# Increase numcpu if you want more cpu's per vm
numcpu = 1

instances = []

(1..numworkers).each do |n| 
  instances.push({:name => "worker#{n}", :ip => "10.2.2.#{n+2}"})
end

manager_ip = "10.2.2.2"
Vagrant.configure("2") do |config|
    config.vm.provider "virtualbox" do |v|
     	v.memory = vmmemory
  	    v.cpus = numcpu
    end
    
    config.vm.define "manager", primary: true do |i|
      i.vm.box = "ubuntu/cosmic64"
      i.vm.hostname = "manager"
      i.vm.network "private_network", ip: "#{manager_ip}"
      config.vm.provision :docker
      i.vm.provision "shell", inline: "docker swarm init --advertise-addr #{manager_ip}"
      i.vm.provision "shell", inline: "docker swarm join-token -q manager > /vagrant/token"
      i.vm.provision "shell", inline: "docker node update --label-add swarmpit.db-data=true $(docker info -f '{{.Swarm.NodeID}}')"
      i.vm.provision "shell", inline: "docker node update --label-add portainer.portainer-data=true $(docker info -f '{{.Swarm.NodeID}}')"
      if configure_ne
        i.vm.provision "shell", path: "./node-exporter.sh"
      end
    end

  instances.each do |instance| 
    config.vm.define instance[:name] do |i|
      i.vm.box = "ubuntu/cosmic64"
      i.vm.hostname = instance[:name]
      i.vm.network "private_network", ip: "#{instance[:ip]}"
      config.vm.provision :docker
      i.vm.provision "shell", inline: "docker swarm join --advertise-addr #{instance[:ip]} --token $(cat /vagrant/token) #{manager_ip}:2377"
      if configure_ne
        i.vm.provision "shell", path: "./node-exporter.sh"
      end
    end
  end
end
