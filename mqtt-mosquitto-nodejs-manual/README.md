This example describes how to create an MQTT network with 3 nodes: A Broker, a Publisher and a Subscriber. It makes use of Mosquitto as the MQTT Broker and Publisher and Subscriber built with NodeJS.

[Diagram Goes Here]

### Requirements

- You'll need a SyntropyStack account and an active Agent Token
- Three separate linux servers running on three separate cloud providers
- All services on a server must run in docker containers (thus docker needs to be installed on each server)
- Each Node must have a Docker network named `syntropynet` and the subnets cannot overlap
- Wireguard must be installed and running on each server

### Setup

There's no coding required as all the examples have been prepared for you, you simply need to setup the servers, copy the relevant files, and bring the services online. You'll connect the endpoints (each node running on its own server is an endpoint in the SyntropyStack).

#### Node 1: The Mosquito Broker

Copy the `broker` directory to your first remote server using `scp` or your favourite `sftp` client.

Eg.

```
scp -r /path/to/broker <user_name>@<remote_ip>:/broker
```

SSH into your remote server.

```
ssh <user>@<remote_ip>
```

You'll need to replace the `SYNTROPY_API_TOKEN` with your own agent token in the `/broker/docker-compose.yaml` file.

```
services:
  syntropynet-agent:
    image: syntropynet/agent:stable
    hostname: syntropynet-agent
    container_name: syntropynet-agent
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    environment:
      - SYNTROPY_API_KEY=<YOUR_API_KEY> # <===== Your token goes here
      - SYNTROPY_NETWORK_API=docker
...

```

Create the docker network.

```
sudo docker network create --subnet 172.20.0.0/24 syntropynet
```

Create, start and attach the `mosquitto` and `syntropynet-agent` services.

```
sudo docker-compose up -d
```

Check that the containers are running with `sudo docker ps`, the output should look something like:

```
CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS              PORTS                                            NAMES
ff3df53e46d6        eclipse-mosquitto          "/docker-entrypoint.…"   About an hour ago   Up 10 minutes       0.0.0.0:1883->1883/tcp, 0.0.0.0:9001->9001/tcp   mosquitto
065e39ce4f8e        syntropynet/agent:stable   "/usr/local/bin/synt…"   About an hour ago   Up 10 minutes                                                        syntropynet-agent
```

Log into your SyntropyStack account and confirm your node is active:

[Image of active node goes here]
