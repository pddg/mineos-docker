# mineos-docker

This container is to use [hexparrot/mineos-node](https://github.com/hexparrot/mineos-node) more useful.

## Usage

Please specify `USER_PASSWORD` to login webui.

```bash
$ docker run --name mineos -p "8443:8443" -p "25565:25565" -e USER_PASSWORD={{Your Password}} pddg/mineos-docker:latest
```

If you want to change username, you have to specify `USER_NAME` (Default is `mc`). And also to change `UID`, you have to specify `USER_UID`, too (Default is `1000`).

```bash
$ docekr run --name mineos -p "8443:8443" -p "25565:25565" -e USER_NAME={{Your name}} -e USER_PASSWORD={{Your Password}} -e USER_UID={{Your UID}} pddg/mineos-docker:latest
```

Original repository is using Self-Signed SSL. This container is disabled its feature by default. So if you want to use it, please add `USE_SELF_SIGNED_SSL` option.

```bash
$ docker run --name mineos -p "8443:8443" -p "25565:25565" -e USER_PASSWORD={{USER_PASSWORD}} -e USE_SELF_SIGNED_SSL="true" pddg/mineos-docker:latest
```

I recommend you to use `docker-compose`.

```yaml
version: "2"
services:
  mineos:
    image: pddg/mineos-docker:latest
    ports:
      - "8443:8443"
      - "25565:25565"
    volumes:
      - ./data:/var/games/minecraft
      - ./path/to/backup:/var/games/minecraft/backup
    environment:
      USER_NAME: hoge
      USER_PASSWORD: fuga
```

When use multiple server on your mineos, please add `ports` settings to routing packet to your container.  

**NOTE**: This container don't have `docker volume`. So if you don't mounted host directory to this, the data will lost on removing of this container.

### Time zone

Default timezone of this is `Asia/Tokyo`. If you want to change it, clon this repo and modify `TZ` variable on `Dockerfile`.  
And run `docker build .`.

## Author

* pudding

## License

MIT



