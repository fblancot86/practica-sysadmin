#!/bin/bash

# Instalación de Nginx y MariaDB
apt-get update
apt-get upgrade -y
apt-get install -y nginx default-jre

systemctl enable nginx
systemctl start nginx

# echo 'JAVA_HOME="/usr/bin/java"' >> /etc/environment

# Configuración de los puntos de montaje
parted /dev/sdc mklabel gpt
parted /dev/sdc mkpart primary ext4 0% 100%
pvcreate /dev/sdc1
vgcreate elasticsearch_vg /dev/sdc1
lvcreate -l 100%FREE elasticsearch_vg -n elasticsearch_data
mkfs.ext4 /dev/elasticsearch_vg/elasticsearch_data
mkdir /var/lib/elasticsearch 
mount /dev/elasticsearch_vg/elasticsearch_data /var/lib/elasticsearch 
echo "/dev/elasticsearch_vg/elasticsearch_data  /var/lib/elasticsearch  ext4    defaults     0  0" >> /etc/fstab

# Configurar repositorio Elastic.co 
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list

# Instalación de Logstash, Elasticsearch y Kibana
apt-get update
apt-get install -y elasticsearch kibana logstash

chown -R elasticsearch:elasticsearch /var/lib/elasticsearch

systemctl enable elasticsearch --now

systemctl enable kibana --now

echo "kibanaadmin:$(openssl passwd -apr1 -in /vagrant/elastic/.kibana)" | sudo tee -a /etc/nginx/htpasswd.users
cp /vagrant/elastic/default /etc/nginx/sites-available

systemctl restart nginx

cp /vagrant/elastic/02-beats-input.conf /etc/logstash/conf.d
cp /vagrant/elastic/10-syslog-filter.conf /etc/logstash/conf.d
cp /vagrant/elastic/30-elasticsearch-output.conf /etc/logstash/conf.d

systemctl enable logstash --now
