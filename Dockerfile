FROM sonarr:latest

LABEL org.freenas.interactive="false" \
      org.freenas.version=1 \
      org.freenas.upgradeable="true" \
      org.freenas.expose-ports-at-host="true" \
      org.freenas.autostart="true" \
      org.freenas.web-ui-protocol="http" \
      org.freenas.web-ui-port=8989 \
      org.freenas.web-ui-path="" \
      org.freenas.port-mappings="8989:8989/tcp,9898:9898/tcp" \
      org.freenas.volumes="[						\
          {								\
              \"name\": \"/config\",					\
              \"descr\": \"Database and Sonarr configs\"		\
          },								\
          {								\
              \"name\": \"/tv\",					\
              \"descr\": \"Location of TV library\"			\
          },								\
          {								\
              \"name\": \"/downloads\",					\
              \"descr\": \"Location of newsreader client downloads\"			\
          }								\
      ]" \
       org.freenas.settings="[ 						                        \
          {								                                    \
              \"env\": \"PUID\",					                              \
              \"descr\": \"SONARR USER ID\",				\
              \"optional\": true					                              \
          },								                              \
          {								                                    \
              \"env\": \"PGID\",					                              \
              \"descr\": \"SONARR GROUP ID\",				\
              \"optional\": true					                              \
          }                                                                               \
      ]"                            \  
      org.freenas.static-volumes="[					\
          {								\
              \"container_path\": \"/dev/rtc\",				\
              \"host_path\": \"/dev/rtc\",				\
              \"readonly\": \"true\"					\
          }								\
      ]" 

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV XDG_CONFIG_HOME="/config/xdg"

# add sonarr repository
RUN \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
 echo "deb http://apt.sonarr.tv/ master main" > \
	/etc/apt/sources.list.d/sonarr.list && \

# install packages
 apt-get update && \
 apt-get install -y \
	libcurl3 \
	nzbdrone && \

# cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8989
VOLUME /config /downloads /tv
