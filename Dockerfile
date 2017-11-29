FROM centos/httpd-24-centos7

USER root

COPY httpd-cfg/httpd.conf /tmp/httpd.conf
COPY scripts/template-config.sh /tmp/template-config.sh
COPY scripts/start.sh /tmp/start.sh

RUN chown 1001:0 /tmp/httpd.conf
RUN chown 1001:0 /tmp/template-config.sh
RUN chown 1001:0 /tmp/start.sh

USER 1001

CMD ["/tmp/start.sh"]