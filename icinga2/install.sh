#!/bin/sh

export DEBIAN_FRONTEND=noninteractive

#Initial install
apt update
apt upgrade -y
apt-get install -y --no-install-recommends apache2 ca-certificates curl dnsutils gnupg locales lsb-release mailutils mariadb-client php-curl php-ldap php-mysql procps pwgen supervisor unzip wget libdbd-mysql-perl

#Install auth_mellon
apt-get install -y --no-install-recommends pkg-config apache2-dev liblasso3-dev libcurl4-openssl-dev
mkdir ~/tmp
cd ~/tmp
wget https://github.com/latchset/mod_auth_mellon/releases/download/v0_16_0/mod_auth_mellon-0.16.0.tar.gz
tar -zxvf mod_auth_mellon*.tar.gz
cd mod_auth_mellon*
./configure
make
make install
echo "LoadModule auth_mellon_module /usr/lib/apache2/modules/mod_auth_mellon.so" > /etc/apache2/mods-enabled/mellon.load
apt-get -y purge apache2-dev liblasso3-dev libcurl4-openssl-dev pkg-config
apt-get autoremove

#Add icinga2 key
curl -s https://packages.icinga.com/icinga.key | apt-key add -
echo "deb http://packages.icinga.org/ubuntu icinga-$(lsb_release -cs) main" > /etc/apt/sources.list.d/icinga2.list
apt update
apt-get install -y --no-install-recommends icinga2 icinga2-ido-mysql icingacli icingaweb2 icingaweb2-module-doc icingaweb2-module-monitoring monitoring-plugins nagios-nrpe-plugin nagios-plugins-contrib nagios-snmp-plugins nsca
a2enmod rewrite
addgroup --system icingaweb2;
usermod -a -G icingaweb2 www-data;
icingacli setup config directory --group icingaweb2;

#Prepare icinga director
useradd -r -g icingaweb2 -d /var/lib/icingadirector -s /bin/false icingadirector
install -d -o icingadirector -g icingaweb2 -m 0750 /var/lib/icingadirector

sed -i 's#command_file.*#command_file=/run/icinga2/cmd/icinga2.cmd#g' /etc/nsca.cfg

icinga2 feature enable api
icinga2 feature enable command
icinga2 feature disable mainlog

apt clean
rm -rf /var/lib/apt/lists/*
