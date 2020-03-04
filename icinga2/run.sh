#!/bin/sh

#Fix permissions
chown www-data:icingaweb2 /etc/icingaweb2 -R 
chown www-data:icingaweb2 /etc/icingaweb2
chown nagios:nagios /etc/icinga2 -R
chown nagios:nagios /etc/icinga2

#Copy config & certificates from volume
cp /etc/icinga2/ca/ca.crt /var/lib/icinga2/ca/ca.crt
cp /etc/icinga2/ca/ca.key /var/lib/icinga2/ca/ca.key
cp /etc/icinga2/certs/* /var/lib/icinga2/certs/
chmod 777 /var/lib/icinga2/certs/*
cp /etc/icingaweb2/icingaweb2.conf /etc/apache2/sites-enabled/icingaweb2.conf

service icinga2 restart
service apache2 restart

icingacli director daemon run &
supervisord -n -c /etc/supervisor/supervisord.conf