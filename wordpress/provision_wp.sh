#!/bin/bash

# Instalación de Nginx y MariaDB
apt-get update
apt-get upgrade -y
apt-get install -y nginx mariadb-server mariadb-common php-fpm php-mysql expect php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip

# Configuración de los puntos de montaje
parted /dev/sdc mklabel gpt
parted /dev/sdc mkpart primary ext4 0% 100%
pvcreate /dev/sdc1
vgcreate wordpress_vg /dev/sdc1
lvcreate -l 100%FREE wordpress_vg -n wordpress_data
mkfs.ext4 /dev/wordpress_vg/wordpress_data
mount /dev/wordpress_vg/wordpress_data /var/lib/mysql
echo "/dev/wordpress_vg/wordpress_data  /var/lib/mysql  ext4    defaults     0  0" >> /etc/fstab


# Habilitar y arrancar servicios Nginx y PHP 
systemctl enable nginx
systemctl start nginx
systemctl enable php7.4-fpm
systemctl start php7.4-fpm

# Configuración de Nginx
cp /vagrant/wordpress/wordpress /etc/nginx/sites-available/
rm  /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/

systemctl restart nginx
systemctl restart php7.4-fpm


# Securizar MariaDB

# Make sure that NOBODY can access the server without a password
mysql -e "UPDATE mysql.user SET Password = PASSWORD('rootpassword') WHERE User = 'root'"
# Kill the anonymous users
mysql -e "DROP USER IF EXISTS ''@'localhost'"
# Because our hostname varies we'll use some Bash magic here.
mysql -e "DROP USER  IF EXISTS''@'$(hostname)'"
# Kill off the demo database
mysql -e "DROP DATABASE IF EXISTS test"
# Make our changes take effect
mysql -e "FLUSH PRIVILEGES"

# Instalación de Wordpress
mysql -u root -prootpassword < /vagrant/wordpress/wordpress.sql

cd /tmp
wget -q https://wordpress.org/latest.tar.gz
tar xzf latest.tar.gz -C /var/www/
chown -R www-data:www-data /var/www/wordpress

# Instalación de Filebeat
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list

apt-get update 
apt-get install filebeat -y

filebeat modules enable system
filebeat modules enable nginx

cp /vagrant/wordpress/filebeat.yml /etc/filebeat/filebeat.yml

systemctl enable filebeat --now
