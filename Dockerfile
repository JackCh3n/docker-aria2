FROM lsiobase/alpine:3.13 as builder

# download static aria2c && AriaNg AllInOne
RUN apk add --no-cache curl unzip \
    && curl -fsSL https://git.io/docker-aria2c.sh | bash

# install static aria2c
FROM lsiobase/alpine:3.13

# set label
LABEL maintainer="NG6"
ENV TZ=Asia/Shanghai UT=true SECRET=Python_No.1 CACHE=128M QUIET=true \
    SMD=true RUT=true PORT=6800 BTPORT=32516 \
    PUID=1026 PGID=100

# copy local files && aria2c
COPY root/ /
COPY --from=builder /usr/local/bin/aria2c /usr/local/bin/aria2c

# install
RUN apk add --no-cache curl jq findutils python3 python3-dev py-pip zlib-dev bzip2-dev pcre-dev openssl-dev ncurses-dev sqlite-dev readline-dev tk-dev gcc g++ make cmake \
    && pip3 install --upgrade pip \
    && pip3 install setuptools \
    && pip3 install aria2p \
    && mkdir -p /mnt/downloads \
    && ln -s /usr/bin/python3.8 /usr/bin/python \
    && chmod a+x /usr/local/bin/aria2c \
    && echo "docker-aria2-$(date +"%Y-%m-%d")" > /aria2/build-date \
    && rm -rf /var/cache/apk/* /tmp/*s

# volume
VOLUME /mnt/downloads

EXPOSE 6800 32516 32516/udp
