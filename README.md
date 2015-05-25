# docker-teamspeak-bechof
Builds an advanced docker image that can run a TeamSpeak Server under Linux.

*Info:* The Log-Path is /var/teamspeak/logs, the database is under /var/teamspeak.
		The admin token is to find in the first two generated logfiles.

## Preparations on the docker host

For this container an empty skel template and the user and group teamspeak with uid and gid 555 is required

**Create empty skel**
```
mkdir /etc/skel_empty
```

**Create user**
```
groupadd -r -g 555 teamspeak && useradd -u 555 -r -g teamspeak -d /data -m -s /sbin/nologin teamspeak
```

## Create and run docker container

**To create the docker image execute**
```
docker build -t bechof/teamspeak .
```

**Running the docker container is done by**
```
docker run -u 555 -d -p=9987:9987/udp -p=10011:10011 -p=30033:30033 -v=/var/teamspeak:/data --name "teamspeak" bechof/teamspeak:latest
```
