# Dockerized `efingerd` Finger Daemon

First let's get this out of the way: I know this is an obscenely large image for a ~20k daemon. If anyone wants to make a much smaller one, please ping me on Mastodon `@jq@fosstodon.org` so I can use yours instead. Consider this a proof of concept and it definitely works, which is something!

All volume mounts are optional, but you almost definitely want to use them.

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
## Considerations

- To add new users, run `docker exec efingerd useradd <name>`. If you don't add the user, `efingerd` won't run their script even if it's there.
- To make `efingerd` respond to a query, you must:
  - add a `/home/<name>/.efingerd` containing a shebang and a command interpreter, ie: `#!/bin/sh`, or `efingerd` won't know what to do.
  - ensure `.efingerd` is readable and executable by `nobody` (chmod 755 is fine)
- The user script can be as simple as echoing information, reading in a file and spitting it out, or really anything you want
- You might want to include `. /etc/efingerd/log` at the top of your script so successful fingers are logged the same as unsuccessful ones
- If you don't choose to bind mount a log file, you can `docker logs --follow efingerd` to watch the logs anyway
- If you DO choose to bind mount a log file, make sure it is writable by `nobody` (chmod 644 is fine)

## World Scripts

If you don't mount `<world-scripts>`, `efingerd` will respond with a lot of information you probably don't want. It is set up this way to preserve mostly default behavior... I say mostly because I have it set to run with the `-n` and `-u` flags. See the [man page](https://manpages.ubuntu.com/manpages/trusty/man8/efingerd.8.html) for details.

If you want the daemon to respond with your own custom information, you should bind mount this directory and put in your own scripts. They all must be executable by `nobody` (chmod 755 is fine).
