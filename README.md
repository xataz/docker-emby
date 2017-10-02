# Emby Image

[![Build Status](https://drone.xataz.net/api/badges/xataz/docker-emby/status.svg)](https://drone.xataz.net/xataz/docker-emby)
[![](https://images.microbadger.com/badges/image/xataz/emby.svg)](https://microbadger.com/images/xataz/emby "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/xataz/emby.svg)](https://microbadger.com/images/xataz/emby "Get your own version badge on microbadger.com")

> This image is build and push with [drone.io](https://github.com/drone/drone), a circle-ci like self-hosted.
> If you don't trust, you can build yourself.

## Tag available
* latest, 3.2.33.0, 3.2, 3 [(Dockerfile)](https://github.com/xataz/dockerfiles/blob/master/emby/Dockerfile)

## Description
What is [Emby](https://github.com/MediaBrowser/Emby) ?

Emby Server is a home media server built on top of other popular open source technologies such as Service Stack, jQuery, jQuery mobile, and Mono.

It features a REST-based API with built-in documention to facilitate client development. We also have client libraries for our API to enable rapid development. 

**This image not contain root process**

## Build Image

```shell
docker build -t xataz/emby github.com/xataz/dockerfiles.git#master:emby
```

## Configuration
### Environments
* UID : Choose uid for launch emby (default : 991)
* GID : Choose gid for launch emby (default : 991)

### Volumes
* /embyData : Configurations files are here

### Ports
* 8096

## Usage
### Speed launch
```shell
docker run -d -p 8096 xataz/emby
```
URI access : http://XX.XX.XX.XX:8096

### Advanced launch
```shell
docker run -d -p 8096 \
	-v /docker/config/emby:/embyData \
	-v /docker/Media:/Media \
	-e UID=1001 \
	-e GID=1001 \
	xataz/emby
```
URI access : http://XX.XX.XX.XX:8096

## Contributing
Any contributions, are very welcome !
