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

EXPOSE 80

ADD start /
ADD init /
RUN chmod +x /init /start

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/appli/"]

CMD ["/start"]
