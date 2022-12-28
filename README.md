# APC PowerChute Business Edition as a Docker container

UPS management, graceful shutdown, and energy management software for servers and workstations using dedicated serial or USB connections.

<https://www.apc.com/us/en/product-range/61932-powerchute-business-edition/>

**This build is for evaluation purposes only and must not violate any APC license restrictions. Use at your own risk.**

## Default username and password
- Username: `apcadm`
- Password: `Qq111111`

## Usage example
I recommend using a Docker `volume` or `bind` mount for persistent data.  
(In this example, the `/docker/apc` data folder is pre-created)

### Docker run
```
docker run \
  --name apc \
  --network host \
  --device=/dev/ttyS0 \
  --env TZ=Europe/Moscow \
  --mount type=bind,source=/docker/apc/.ssh/,target=/root/.ssh/ \
  --mount type=bind,source=/docker/apc/cmdfiles/,target=/opt/APC/PowerChuteBusinessEdition/Agent/cmdfiles/ \
  --restart always \
  --detach \
  starina/powerchute:ubuntu-latest
```

### Custom config
```
docker exec -it apc bash config.sh
docker restart apc
```
### Web interface
<https://localhost:6547>

## After the first launch and configuration

You can take files `DataLog` `EventLog` `m11.cfg` `pcbeconfig.ini` out of the container and mount them permanently.  
(In this example, the `/docker/apc` data folder is pre-created)

```
for F in DataLog EventLog m11.cfg pcbeconfig.ini
do
  docker cp apc:/opt/APC/PowerChuteBusinessEdition/Agent/$F /docker/apc/
done

docker stop apc
docker rm apc

docker run \
  --name apc \
  --network host \
  --device=/dev/ttyS0 \
  --env TZ=Europe/Moscow \
  --mount type=bind,source=/docker/apc/DataLog,target=/opt/APC/PowerChuteBusinessEdition/Agent/DataLog \
  --mount type=bind,source=/docker/apc/EventLog,target=/opt/APC/PowerChuteBusinessEdition/Agent/EventLog \
  --mount type=bind,source=/docker/apc/m11.cfg,target=/opt/APC/PowerChuteBusinessEdition/Agent/m11.cfg \
  --mount type=bind,source=/docker/apc/pcbeconfig.ini,target=/opt/APC/PowerChuteBusinessEdition/Agent/pcbeconfig.ini \
  --mount type=bind,source=/docker/apc/.ssh/,target=/root/.ssh/ \
  --mount type=bind,source=/docker/apc/cmdfiles/,target=/opt/APC/PowerChuteBusinessEdition/Agent/cmdfiles/ \
  --restart always \
  --detach \
  starina/powerchute:ubuntu-latest
```

## Further help and docs
For any help specific to APC please have a look at <https://www.apc.com/us/en/product-range/61932-powerchute-business-edition/#documents>
