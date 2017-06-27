#!/bin/bash

EMBY_VERSION=$(grep "EMBY_VER=" Dockerfile | cut -d"=" -f2)
NEW_EMBY_VERSION=$(curl https://github.com/MediaBrowser/Emby/releases/latest 2> /dev/null | sed 's#.*tag/##;s#">.*##')
MEDIAINFO_VERSION=$(grep "MEDIAINFO_VER=" Dockerfile | cut -d"=" -f2)
NEW_MEDIAINFO_VERSION=$(curl https://mediaarea.net/en/MediaInfo 2> /dev/null | grep -Eo '[0-9]{1,4}\.[0-9]{1,4}\.[0-9]{1,4}')


f_gen_tag() {
    VERSION=$1

    TAGS="latest ${VERSION} $(echo ${VERSION} | cut -d'.' -f '1 2') $(echo ${VERSION} | cut -d'.' -f '1')"
}

f_maj_dockerfile() {
    BUILD_VER=$(date +%Y%m%d01)

    ## Edit dockerfile
    sed -i 's/EMBY_VER=.*/EMBY_VER='${NEW_EMBY_VERSION}'/;
        s/MEDIAINFO_VER=.*/MEDIAINFO_VER='${NEW_MEDIAINFO_VERSION}'/;
        s/tags=".*"/tags="'"${TAGS}"'"/;
        s/build_ver=".*"/build_ver="'${BUILD_VER}'"/' Dockerfile
    
}

f_maj_readme() {
    VERSION=$1
    TAGS=$(echo $TAGS | sed 's/ /, /g')

    sed -i 's#\* .*/Dockerfile)#\* '"${TAGS}"' \[(Dockerfile)\](https://github.com/xataz/dockerfiles/blob/master/emby/Dockerfile)#' README.md
}

if [ "${EMBY_VERSION}" != "${NEW_EMBY_VERSION}" ] || [ "${MEDIAINFO_VERSION}" != "${NEW_MEDIAINFO_VERSION}" ]; then
    echo "Update emby to ${NEW_EMBY_VERSION}"
    f_gen_tag ${NEW_EMBY_VERSION}
    f_maj_dockerfile
    f_maj_readme
fi