<center><img src='https://github.com/lorenzo8769/syntropynet-use-cases/blob/mon-1-ui-1/grafana-prometheus-node_exporter-ui/images/Logo.png'></center>



# Monitoring solution with Grafana, Prometheus, node_exporter and Nginx

Description / Requirements :

- Create a monitoring network with minimum 3 nodes (preferably on different providers) with node_exporter, Prometheus, Grafana and Nginx (with Let’s Encrypt SSL certificates).
- There must be __no ports exposed to the internet__ (except Nginx 443 with SSL). Set up your firewall accordingly.

## To start, build 3x VM from 3x different providers (preferablyto start, build 3x VM from 3x Different Suppliers (preferably)

- First VM:   __Nginx + Grafana__
- Second VM:  __Prometheus__
- Third VM:   __Node-Exporter__

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

<center><img src='https://github.com/lorenzo8769/syntropynet-use-cases/blob/mon-1-ui-1/grafana-prometheus-node_exporter-ui/images/End-Point.png'></center>


## Launch services on each dedicated VM. Be careful by launching them on a different subnet:

First VM:
   
```bash
sudo docker network create --subnet 172.20.0.0/24 syntropynet
```

Second VM:

```bash
sudo docker network create --subnet 172.21.0.0/24 syntropynet
```

Third VM:

```bash
sudo docker network create --subnet 172.22.0.0/24 syntropynet
```

## First VM (replace dedicated fields):

- Create Domain on DuckDNS - https://www.duckdns.org/ and redirect on your Public IP

<center><img src='https://github.com/lorenzo8769/syntropynet-use-cases/blob/mon-1-ui-1/grafana-prometheus-node_exporter-ui/images/DuckDNS.png'></center>


- Launch docker

```bash
sudo docker run --detach --net=syntropynet \
--name nginx-proxy \
--publish 80:80 \
--publish 443:443 \
--volume /etc/nginx/certs \
--volume /etc/nginx/vhost.d \
--volume /usr/share/nginx/html \
--volume /var/run/docker.sock:/tmp/docker.sock:ro \
jwilder/nginx-proxy
```

```bash
sudo docker run --detach --net=syntropynet \
--name nginx-proxy-letsencrypt \
--volumes-from nginx-proxy \
--volume /var/run/docker.sock:/var/run/docker.sock:ro \
--volume /etc/acme.sh \
--env "DEFAULT_EMAIL=mail@domain" \
jrcs/letsencrypt-nginx-proxy-companion
```

```bash
sudo docker run --detach --net=syntropynet \
--name grafana \
--env "VIRTUAL_HOST=DuckDNSDomain" \
--env "VIRTUAL_PORT=3000" \
--env "LETSENCRYPT_HOST=DuckDNSDomain" \
--env "LETSENCRYPT_EMAIL=mail@domain" \
--env "GF_SECURITY_ADMIN_USER=admin" \
--env "GF_SECURITY_ADMIN_PASSWORD=syntropy" \
--env "GF_USERS_ALLOW_SIGN_UP=false" \
grafana/grafana
```

## Second VM (set up after the third VM):

- Create the file "prometheus.yml"

```bash    
sudo nano prometheus.yml
```

- Paste in __prometheus.yml__

```bash
      global:
        scrape_interval: 5s
        external_labels:
          monitor: 'node'
      scrape_configs:
        - job_name: 'prometheus'
          static_configs:
            - targets: ['DOCKER_IP_PROMETHEUS:9090']
        - job_name: 'node-exporter'
          static_configs:
            - targets: ['DOCKER_IP_EXPORTER:9100']
```

- Launch docker (after the third VM) - Do not expose port 9090 to the internet 

```bash
sudo docker run --net=syntropynet -d --name prometheus -v $PWD/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus:latest
```

## Third VM: 

- Launch docker - Do not expose port 9100 to the internet 

```bash
sudo docker run --net=syntropynet -d --name node-exporter quay.io/prometheus/node-exporter
```

<center><img src='https://github.com/lorenzo8769/syntropynet-use-cases/blob/mon-1-ui-1/grafana-prometheus-node_exporter-ui/images/End-Point%20and%20Services.png'></center>



## Create your Network and Add all End-Point

<center><img src='https://github.com/lorenzo8769/syntropynet-use-cases/blob/mon-1-ui-1/grafana-prometheus-node_exporter-ui/images/Create-Network.png'></center>
<center><img src='https://github.com/lorenzo8769/syntropynet-use-cases/blob/mon-1-ui-1/grafana-prometheus-node_exporter-ui/images/Network%20Syntropy.png'></center>



## Interconnect services

<center><img src='https://github.com/lorenzo8769/syntropynet-use-cases/blob/mon-1-ui-1/grafana-prometheus-node_exporter-ui/images/Network_Topology.png'></center>
<center><img src='https://github.com/lorenzo8769/syntropynet-use-cases/blob/mon-1-ui-1/grafana-prometheus-node_exporter-ui/images/Network_Interonnexion.png'></center>



## Configuration Grafana

- Connect to https://DuckerDNSDomain address + Add DataSource Prometheus and identify DOCKER_IP_PROMETHEUS

<center><img src='https://github.com/lorenzo8769/syntropynet-use-cases/blob/mon-1-ui-1/grafana-prometheus-node_exporter-ui/images/Grafana.png'></center>
<center><img src='https://github.com/lorenzo8769/syntropynet-use-cases/blob/mon-1-ui-1/grafana-prometheus-node_exporter-ui/images/DataSource-Prometheus.png'></center>

- Import (Create > Import) this Dashboard: https://grafana.com/grafana/dashboards/11074
<center><img src='https://github.com/lorenzo8769/syntropynet-use-cases/blob/mon-1-ui-1/grafana-prometheus-node_exporter-ui/images/SnapShot%20Node%20Exporter%20with%20Prometheus%20on%20Grafana.png'></center>


__Congratulations, your architecture is up and running ;-)__


## Tutorial Video
https://www.loom.com/share/2b34174b60d84d6eabd80114b6ba1acb


