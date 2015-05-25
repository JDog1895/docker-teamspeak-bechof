# -----------------------------------------------------------------------------
# docker-teamspeak-bechof
#
# Builds an advanced docker image that can run TeamSpeak
# (http://teamspeak.com/).
#
# Authors: Matthias Becker, Axel Hoffmann
# Updated: Feb 5th, 2015
# Require: Docker (http://www.docker.io/)
# -----------------------------------------------------------------------------

# Base system is Debian 8 (Jessie)
FROM   debian:8

# The glory team
MAINTAINER Matthias Becker, Axel Hoffmann

# Make sure that everything is running as root
USER   root

# Make sure we don't get notifications we can't answer during building.
ENV    DEBIAN_FRONTEND noninteractive

# Variable for teamspeak download path (change for newer version)
ENV    TEAMSPEAK_URL http://dl.4players.de/ts/releases/3.0.11.2/teamspeak3-server_linux-amd64-3.0.11.2.tar.gz

# Update packet repository and upgrade packages
RUN    apt-get --yes update; apt-get --yes upgrade

# Create Teamspeak User
RUN    groupadd -r -g 555 teamspeak && useradd -u 555 -r -g teamspeak -d /data -m -s /sbin/nologin teamspeak 

# Download TeamSpeak and unpack it to /opt/teamspeak and set correct permissions
ADD ${TEAMSPEAK_URL} /opt/
RUN     cd /opt && tar -xzf team*.tar.gz && rm *.tar.gz && mv team* teamspeak && chown teamspeak:teamspeak -R teamspeak && chmod 750 teamspeak

# Symlink the database to the persistent /data directory
RUN    ln -s /data/ts3server.sqlitedb /opt/teamspeak/ts3server.sqlitedb

# Copy start script to the image
ADD    ./scripts/start /start

# Execute permissions for start script
RUN    chmod +x /start

# Expose ports for TeamSpeak
EXPOSE 9987/udp
EXPOSE 10011
EXPOSE 30033

# Switch to teamspeak user, because TeamSpeak should run as non-root
USER teamspeak
VOLUME ["/data"]

ENTRYPOINT    ["/start"]

