# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "Wordpress" do |wordpress|
    wordpress.vm.box = "ubuntu/focal64"
    wordpress.vm.box_check_update = false
    wordpress.vm.hostname = "Wordpress"
    wordpress.vm.network "private_network", ip: "192.168.0.10", nic_type: "virtio", virtualbox__intnet: "keepcoding"
    wordpress.vm.network "forwarded_port", guest: 80, host: 8080
    wordpress.vm.provider "virtualbox" do |vb|
      vb.name = "Wordpress"
      vb.memory = "1024"
    end
  end

  config.vm.define "Elasticsearch" do |elastic|
    elastic.vm.box = "ubuntu/focal64"
    elastic.vm.box_check_update = false
    elastic.vm.hostname = "Elasticsearch"
    elastic.vm.network "private_network", ip: "192.168.0.20", nic_type: "virtio", virtualbox__intnet: "keepcoding"
    elastic.vm.network "forwarded_port", guest: 80, host: 8081
    elastic.vm.network "forwarded_port", guest: 9200, host: 8082
    elastic.vm.provider "virtualbox" do |vb|
      vb.name = "Elasticsearch"
      vb.memory = "3072"
    end
  end  
end
