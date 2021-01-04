# Nginx and curl client

Description / Requirements :

- Create a network with 2 nodes - nginx and curl client. Each node must run in different clouds.
- There must be __no ports exposed to the internet__ (except Nginx 443 with SSL). Set up your firewall accordingly. You can't use -p flag.

## To start, build 2x VM from 2x different providers

- First VM:   __Nginx__ You can't use -p flag
- Second VM:  __Cloud1__

## Start Syntropy Agent on every VM with this command (generate a token/api key on the platform https://platform.syntropystack.com ):

```bash
sudo docker run --network="host" --restart=on-failure:10 --cap-add=NET_ADMIN --cap-add=SYS_MODULE \
-v /var/run/docker.sock:/var/run/docker.sock:ro \
--device /dev/net/tun:/dev/net/tun --name=syntropynet-agent \
-e SYNTROPY_API_KEY=CHANGE ME \
-e SYNTROPY_TAGS=CHANGE ME \
-e SYNTROPY_PROVIDER=CHANGE ME \
-e SYNTROPY_AGENT_NAME=CHANGE ME \
-e SYNTROPY_NETWORK_API='docker' \
-d syntropynet/agent:stable
```

# Launch services on each dedicated VM

## First VM (replace dedicated fields):

- Create Docker Network

```bash
sudo docker network create --subnet 172.10.0.0/24 syntropynet
```

- Launch docker

```bash
sudo docker run --detach --net=syntropynet --name nginx nginx
```

## Create your Network and Add all End-Point


## Interconnect services


## Since Second VM

- Launch curl
```bash
curl http://nginx_docker_ip
```

- you should see that:
```bash
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```


__Congratulations, your architecture is up and running ;-)__
