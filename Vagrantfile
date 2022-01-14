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

      file_to_disk = "wordpress_disk.vmdk"
      unless File.exist?(file_to_disk)
          vb.customize [ "createmedium", "disk", "--filename", file_to_disk, "--format", "vmdk", "--size", 1024 * 1 ]
      end
      vb.customize [ "storageattach", "Wordpress" , "--storagectl", "SCSI", "--port", "2", "--device", "0", "--type", "hdd", "--medium", file_to_disk]
    end
    wordpress.vm.provision "shell", path: "wordpress/provision_wp.sh"
  end

  config.vm.define "Elastic" do |elastic|
    elastic.vm.box = "ubuntu/focal64"
    elastic.vm.box_check_update = false
    elastic.vm.hostname = "Elastic"
    elastic.vm.network "private_network", ip: "192.168.0.20", nic_type: "virtio", virtualbox__intnet: "keepcoding"
    elastic.vm.network "forwarded_port", guest: 80, host: 9090
    elastic.vm.network "forwarded_port", guest: 9200, host: 9200
    elastic.vm.provider "virtualbox" do |vb|
      vb.name = "Elastic"
      vb.memory = "4096"

      file_to_disk = "elastic_disk.vmdk"
      unless File.exist?(file_to_disk)
          vb.customize [ "createmedium", "disk", "--filename", file_to_disk, "--format", "vmdk", "--size", 1024 * 1 ]
      end
      vb.customize [ "storageattach", "Elastic" , "--storagectl", "SCSI", "--port", "2", "--device", "0", "--type", "hdd", "--medium", file_to_disk]
    end
    elastic.vm.provision "shell", path: "elastic/provision_elk.sh"
  end  
end
