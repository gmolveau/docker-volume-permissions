# docker-volume-permissions

An example on how to avoid volume permissions problems with docker (compose) with a user without root privileges

This example solves this problem with a custom entrypoint, that reads env variables to change the `UID` and `GID` of the current user of the docker container to match the desired ones (usually the current user of the host).

Take into consideration that with this solution, the container initially starts as root, but the entrypoint then switches to another user to run your command.

It is possible to use another method using the `setuid` bit of the script, but it has some caveats (eg. impossible to restart a container because the setuid can only be used once - so only useful for **ephemeral** containers).

Please note that the `$UID` and `$GID` are `shell` variables, not environment variables. It is not possible to use them directly in the docker compose file. So if you want to dynamically get the `$UID` and `$GID` of the current user, a script (or a makefile) can be used to set those env variables dynamically.

For example : `PUID=$(id -u) PGID=$(id -g) docker compose up -d`.

## Try it

```shell
docker compose build --no-cache

PUID=$(id -u) PGID=$(id -g) docker compose up
# or
make run
# notice that a `ok.txt` file has been created with the correct permissions in the `data` folder
docker compose down
docker image rm vol:test
```

## Other solutions

- use named volumes, not bind-hosted
- use a S3 storage (eg. minio)
- use [s6-overlay](https://github.com/just-containers/s6-overlay) with `s6-setuidgid`

## Sources and inspirations

- <https://mydeveloperplanet.com/2022/10/19/docker-files-and-volumes-permission-denied/>
- <https://pratikpc.medium.com/use-docker-compose-named-volumes-as-non-root-within-your-containers-1911eb30f731>
- <https://github.com/linuxserver/docker-plex/blob/7e8f9d66876fe8e2f98ed69f20f79dc143a3c4f8/README.md?plain=1#L206-L223>'
- <https://github.com/linuxserver/docker-plex/blob/7e8f9d66876fe8e2f98ed69f20f79dc143a3c4f8/root/etc/s6-overlay/s6-rc.d/init-plex-chown/run#L11-L17>
- <https://github.com/linuxserver/docker-baseimage-ubuntu/blob/fe39690d802969da2a5ca11a04f8dd3088238fb0/root/etc/s6-overlay/s6-rc.d/init-adduser/run#L4-L8>
- <https://github.com/FooBarWidget/matchhostfsowner>
