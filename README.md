# sysadmin-francesc
Practica sysadmin Francesc Blanco

Requisitos:
 - Oracle VM VirtualBox
 - Vagrant
 - Git

Obtener Máquinas Virtuales:
 - git clone git@github.com:KeepCodingCloudDevops5/sysadmin-francesc.git
 - cd sysadmin-francesc
 - vagrant up
 
Este proceso puede tardar varios minutos.
Levantará 2 máquinas virtuales:
 - Máquina Wordpress: Aprovisionada con Nginx, MariaDB, Wordpress y Filebeat.
 - Máquina Elastic: Aprovisionada con Nginx, Logstash, Kibana y Elasticsearch.
 
En este punto, se podrá acceder al puerto 8080 de localhost para entrar y configurar Wordpress con los siguientes datos:
 - Base de datos: wordpress
 - Usuario de la base de datos: wordpressuser
 - Contraseña: keepcoding
 
Para entrar al portal de Kibana se debe acceder al puerto 9090 de localhost con las siguientes credenciales:
 - Usuario: kibanaadmin
 - Contraseña: keepcoding
