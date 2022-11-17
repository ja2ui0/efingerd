# Dockerized `efingerd` Finger Daemon

Thanks to [@lack@fosstodon.org](https://fosstodon.org/@lack) for some insight about `socat` that allowed a rebase from Ubuntu to Alpine, reducing the image size from ~120MB to about ~8MB. Also, binaries had to be recompiled for Alpine (musl) from [efingerd_1.6.7](http://deb.debian.org/debian/pool/main/e/efingerd/efingerd_1.6.7.orig.tar.gz) and [libident_0.32](https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/libident/0.32-1/libident_0.32.orig.tar.gz).

Have a look at the [efingerd man page](https://manpages.ubuntu.com/manpages/trusty/man8/efingerd.8.html).

All volume mounts are optional, but you probably want to use them.

## Docker Run
```
docker run -d -p 79:79 \
  --name efingerd \
  -v <world-scripts>:/etc/efingerd \
  -v <user-scripts>:/home \
  -v <logfile>:/var/log/efingerd.log \
  ja2ui0/efingerd
```

## Docker Compose
```
version: "3"
services:
  efingerd:
    image: ja2ui0/efingerd
    container_name: efingerd
    volumes:
      - <world-scripts>:/etc/efingerd
      - <user-scripts>:/home
      - <logfile>:/var/log/efingerd.log
    ports:
      - 79:79
    restart: unless-stopped
```
## Volumes

- `world-scripts`: how efingerd handles requests you don't explicitly define
  - if you want to change logging, or anything related to undefined users, mount your own here
  - don't change the names of the scripts, only the contents
- `user-scripts`: - Where you put your .efingerd scripts for named users
- `logfile`: if you want to see the IPs that are fingering your host

## Considerations

- To add new users, run `docker exec efingerd useradd <name>`. If you don't add the user, `efingerd` won't run their script even if it's there.
- To make `efingerd` respond to a query, you must:
  - add a `/home/<name>/.efingerd` containing a shebang and a command interpreter, ie: `#!/bin/sh`, or `efingerd` won't know what to do.
  - ensure `.efingerd` is readable and executable by `nobody` (chmod 755 is fine)
- The user script can be as simple as echoing information, reading in a file and spitting it out, or really anything you want
- You might want to include `. /etc/efingerd/log` at the top of your script so successful fingers are logged the same as unsuccessful ones
- If you choose to bind mount a log file, make sure it is writable by `nobody` (chmod 644 is fine)
- The image on Docker Hub is built with the `-n` and `-f` flags. See the [man page](https://manpages.ubuntu.com/manpages/trusty/man8/efingerd.8.html) for details.

## `examples-standard`

These are the main scripts that ship with the original package. They will break horribly if you use them, since many of the binaries on which they depend are not available in the image (or Alpine in general, unless you compile from source). They are included in this repo so you can see what this daemon was designed to be able to do.
