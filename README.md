# Docker Redis

Docker image for Redis 2.8

## Build the image
```shell
docker build -t audioandpixels/redis github.com/audioandpixels/docker-redis
```

## Container requirements

#### Environment Variables
```
AWS_SECRET_ACCESS_KEY=xxxxxxxx
AWS_ACCESS_KEY_ID=xxxxxxxx
REDIS_PASSWORD=xxxx
```

####External volumes
```
$HOME/redis/data
$HOME/redis/log
```

## Basic usage

####Create external volumes
```shell
$ mkdir $HOME/redis && chown root:root $HOME/redis && chmod 0700 $HOME/redis
$ mkdir $HOME/redis/data && chown root:root $HOME/redis/data && chmod 0700 $HOME/redis/data
$ mkdir $HOME/redis/log && chown root:root $HOME/redis/log && chmod 0700 $HOME/redis/log
```

####Start the container...

```shell
$ docker run -d -p 6379:6379 -v "$HOME/redis/data":"/var/lib/redis" -v "$HOME/redis/log":"/var/log" -e AWS_SECRET_ACCESS_KEY=xxxxxxxx -e AWS_ACCESS_KEY_ID=xxxxxxxx -e REDIS_PASSWORD=xxxx audioandpixels/redis
```

The image starts cron, syslog, and Redis. [runit][runit] manages the cron and Redis processes and will restart them automatically if they crash.

## License

MIT license.

[wal-e]:  https://github.com/wal-e/wal-e
[runit]:  http://smarden.org/runit/
