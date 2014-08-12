#******************************************************************
# Ecloud Dockerfile
# Service : Postgres
# Author : Mathieu GOULIN
# Date : 21/07/2014
#******************************************************************
# Updates :
#
#******************************************************************

# Ubuntu
FROM ubuntu
MAINTAINER matgou@kapable.info

# Install postgres-9.3
RUN apt-get update
RUN apt-get -y -q install nginx php5-fpm php5-intl php5-pgsql php5-mysql php5-xsl supervisor

EXPOSE 80

ADD start /
ADD init /
RUN chmod +x /init /start
#RUN /tmp/init-slapd.sh /appli/ldap openldap openldap

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/appli/"]

CMD ["/start"]
