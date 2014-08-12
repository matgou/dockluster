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

# update package list
RUN apt-get update
RUN apt-get -qy install openvpn easy-rsa

# Add start script
ADD start /
ADD init /
RUN chmod +x /start /init

# Expose
EXPOSE 1194/udp 
VOLUME  ["/appli/"]
CMD ["/start"]
