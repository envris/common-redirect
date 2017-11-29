FROM centos/httpd-24-centos7

COPY httpd-cfg/httpd.conf /tmp/httpd.conf
COPY scripts/template-config.sh /tmp/template-config.sh
COPY scripts/start.sh /tmp/start.sh
CMD ["/tmp/start.sh"]