[![](https://images.microbadger.com/badges/image/alpin3/ulx3s.svg)](https://microbadger.com/images/alpin3/ulx3s "Get your own image badge on microbadger.com")
[![Docker Pulls](https://img.shields.io/docker/pulls/alpin3/ulx3s)](https://hub.docker.com/r/alpin3/ulx3s "Docker hub")
[![Travis (.org)](https://img.shields.io/travis/alpin3/ulx3s)](https://travis-ci.org/alpin3/ulx3s "Travis CI")

# ulx3s

Everyhing needed for [ulx3s FPGA](https://radiona.org/ulx3s/) in binary or Docker form. Check [releases](https://github.com/alpin3/ulx3s/releases).

# Run

If you don't plan repluggin the FPGA often, just run with device path where your FPGA is connected:

```
docker run --device=/dev/ttyUSB0 -it alpin3/ulx3s
```

If you don't care too much about security and plan repluggin a lot:

```
docker run --privileged -v /dev:/dev -it alpin3/ulx3s
```

Check out [Docker - a way to give access to a host USB or serial device?](https://stackoverflow.com/questions/24225647/docker-a-way-to-give-access-to-a-host-usb-or-serial-device)

# Static binaries

If you just plan to get the static binaries yourself:
```
docker run -it --name ulx3sbin alpin3/ulx3s true
docker cp ulx3sbin:/usr/local/bin static-bin
docker rm ulx3sbin
```

If you just plan to build the static binaries yourself:
```
https://github.com/alpin3/ulx3s.git
cd ulx3s
docker build -t test/ulx3s .
docker run -it --name ulx3sbin test/ulx3s true
docker cp ulx3sbin:/usr/local/bin static-bin
docker rm ulx3sbin
```





