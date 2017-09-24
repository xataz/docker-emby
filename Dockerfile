FROM xataz/mono:5

ARG MEDIAINFO_VER=0.7.98
ARG EMBY_VER=3.2.30.0

ENV GID=991 \
    UID=991 \
    PREMIERE=false

LABEL description="Emby based on alpine" \
      tags="latest 3.2.32.0 3.2 3" \
      maintainer="xataz <https://github.com/xataz>" \
      build_ver="2017090601"

RUN export BUILD_DEPS="build-base \
                        git \
                        unzip \
                        wget \
                        ca-certificates \
                        xz" \
    && apk add --no-cache imagemagick \
	            sqlite-libs \
	            ffmpeg \
	            s6 \
                su-exec \
                $BUILD_DEPS \
    && wget http://mediaarea.net/download/binary/mediainfo/${MEDIAINFO_VER}/MediaInfo_CLI_${MEDIAINFO_VER}_GNU_FromSource.tar.xz -O /tmp/MediaInfo_CLI_${MEDIAINFO_VER}_GNU_FromSource.tar.xz \
    && wget http://mediaarea.net/download/binary/libmediainfo0/${MEDIAINFO_VER}/MediaInfo_DLL_${MEDIAINFO_VER}_GNU_FromSource.tar.xz -O /tmp/MediaInfo_DLL_${MEDIAINFO_VER}_GNU_FromSource.tar.xz \
    && tar xJf /tmp/MediaInfo_DLL_${MEDIAINFO_VER}_GNU_FromSource.tar.xz -C /tmp \
    && tar xJf /tmp/MediaInfo_CLI_${MEDIAINFO_VER}_GNU_FromSource.tar.xz -C /tmp \
    && cd  /tmp/MediaInfo_DLL_GNU_FromSource \
    && ./SO_Compile.sh \
    && cd /tmp/MediaInfo_DLL_GNU_FromSource/ZenLib/Project/GNU/Library \
    && make install \
    && cd /tmp/MediaInfo_DLL_GNU_FromSource/MediaInfoLib/Project/GNU/Library \
    && make install \
    && cd /tmp/MediaInfo_CLI_GNU_FromSource \
    && ./CLI_Compile.sh \
    && cd /tmp/MediaInfo_CLI_GNU_FromSource/MediaInfo/Project/GNU/CLI \
    && make install \
    && mkdir /embyServer /embyData \
    && wget https://github.com/MediaBrowser/Emby/releases/download/${EMBY_VER}/Emby.Mono.zip -O /tmp/Emby.Mono.zip \
    && ln -s /usr/lib/libsqlite3.so.0 /usr/lib/libsqlite3.so \
    && unzip /tmp/Emby.Mono.zip -d /embyServer \
    && apk del --no-cache $BUILD_DEPS \
    && rm -rf /tmp/*

EXPOSE 8096 8920 7359/udp
VOLUME /embyData
ADD rootfs /
RUN chmod +x /usr/local/bin/startup

ENTRYPOINT ["/usr/local/bin/startup"]
CMD ["s6-svscan", "/etc/s6.d"]
