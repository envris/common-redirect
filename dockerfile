FROM httpd:2.4.29-alpine

COPY ./httpd-cfg/httpd.cfg /usr/local/apache2/conf/httpd.conf