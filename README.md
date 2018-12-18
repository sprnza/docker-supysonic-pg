# speranza/supysonic
Dockerize [Supysonic](https://github.com/spl0k/supysonic) postgresql edition with watcher included. Based on [mikafouenski/docker-supysonic](https://github.com/mikafouenski/docker-supysonic).

## Usage

```
docker create \
    --name supysonic\
    -p 8000:8000 \
    -e PUID=<UID> -e PGID=<GID> \
    -e WORKERS=<nbthread> \ 
    -e WATCHER=0 \ 
    -v </path/to/sypysonic.conf>:/etc/supysonic.conf \
    -v <path/to/music>:/media:ro \
    mikafouenski/supysonic
```

* `-p 8000` - the port supysonic webinterface
* `-v /etc/supysonic.conf` - supysonic conf
* `-v /media` - location of music library on disk (ro = readonly)
* `-e PGID` for for GroupID, default 2000 - see below for explanation
* `-e PUID` for for UserID, default 2000 - see below for explanation
* `-e WORKERS` for the number of threads, default 4
* `-e WATCHER` start the supysonic watcher processus to refresh librairy automaticaly. default = 1 (run it !)

Docker-compose exemple :
```
  supysonic:
    image: 'mikafouenski/supysonic'
    container_name: 'supysonic'
    restart: 'unless-stopped'
    environment:
      - PUID=<UID>
      - PGID=<GID>
    volumes:
      - '</path/to/supysonic.conf>:/etc/supysonic.conf'
      - '<path/to/music>:/media'
    ports:
      - 8000:8000
  postgres:
    image: postgres:10.5
    restart: always
    volumes:
      - /path/to/pg/data:/var/lib/postgresql/data
      - /path/to/postgres.conf:/etc/postgres.conf
      - /path/to/pg_hba.conf:/etc/pg_hba.conf
    command: postgres -c config_file=/etc/postgres.conf
    ports:
      - 8000:8000
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
  
```

It is based on alpine with [S6 overlay](http://skarnet.org/software/s6/index.html).

## Supysonic init

Once the container is running we can create users with the client interface :
```
docker exec -it supysonic supysonic-cli
```

Ex: 
* Create an admin user: `user add -a <username>`
* Add a folder and scan it: `folder add Music /music` and then `folder scan Music`

The documentation of these commands can be found on the supysonic project ([here](https://github.com/spl0k/supysonic/blob/master/docs/cli.md)).

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work".

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application
Access the webui at `<your-ip>:8000`.

