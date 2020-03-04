FROM ubuntu:bionic


COPY install.sh /tmp/install.sh
RUN chmod +x /tmp/install.sh
RUN /tmp/install.sh

COPY run.sh /run.sh
RUN chmod +x /run.sh 
COPY nsca.conf /etc/supervisor/conf.d/nsca.conf
COPY apache2_supervisor.conf /etc/supervisor/conf.d/apache2.conf

COPY install_checks.sh /tmp/install_checks.sh
RUN chmod +x /tmp/install_checks.sh
RUN /tmp/install_checks.sh

VOLUME ["/icinga2conf","/icingaweb2"]

EXPOSE 80 5667 5665

CMD ["/run.sh"]
