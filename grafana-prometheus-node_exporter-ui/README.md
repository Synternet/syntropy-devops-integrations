# Monitoring solution with Grafana, Prometheus, node_exporter and Nginx

Description:

Create a monitoring network with minimum 3 nodes (preferably on different providers) with node_exporter, Prometheus, Grafana and Nginx (with Let’s Encrypt SSL certificates).

## To start, build 3x VM from 3x different providers (preferablyto start, build 3x VM from 3x Different Suppliers (preferably)

- First VM:   __Nginx + Grafana__
- Second VM:  __Prometheus__
- Third VM:   __Node-Exporter__

## Start Syntropy Agent on every VM with this command (generate a token/api key on the platform):

     docker run --network="host" --restart=on-failure:10 --cap-add=NET_ADMIN --cap-add=SYS_MODULE \
     -v /var/run/docker.sock:/var/run/docker.sock:ro \
     --device /dev/net/tun:/dev/net/tun --name=syntropynet-agent \
     -e SYNTROPY_API_KEY=CHANGE ME \
     -e SYNTROPY_TAGS=CHANGE ME \ 
     -e SYNTROPY_PROVIDER=CHANGE ME \
     -e SYNTROPY_AGENT_NAME=CHANGE ME \
     -e SYNTROPY_NETWORK_API='docker' \
     -d syntropynet/agent:stable

## Launch services on each dedicated VM. Be careful by launching them on a different subnet:

First VM:
   
      docker network create --subnet 172.10.0.0/24 syntropynet
     
Second VM:

      docker network create --subnet 172.20.0.0/24 syntropynet
     
Third VM:

      docker network create --subnet 172.30.0.0/24 syntropynet
         
## First VM (replace dedicated fields):

- Create Domain on DuckDNS - https://www.duckdns.org/ and redirect on your Public IP

- Launch docker
     
      docker run --detach --net=syntropynet \'' 
      --name nginx-proxy \
      --publish 80:80 \
      --publish 443:443 \
      --volume /etc/nginx/certs \
      --volume /etc/nginx/vhost.d \
      --volume /usr/share/nginx/html \
      --volume /var/run/docker.sock:/tmp/docker.sock:ro \
      jwilder/nginx-proxy

      docker run --detach --net=syntropynet \
      --name nginx-proxy-letsencrypt \
      --volumes-from nginx-proxy \
      --volume /var/run/docker.sock:/var/run/docker.sock:ro \
      --volume /etc/acme.sh \
      --env "DEFAULT_EMAIL=mail@domain" \
      jrcs/letsencrypt-nginx-proxy-companion

      docker run --detach --net=syntropynet \
      --name grafana \
      --env "VIRTUAL_HOST=DuckDNSDomain" \
      --env "VIRTUAL_PORT=3000" \
      --env "LETSENCRYPT_HOST=DuckDNSDomain" \
      --env "LETSENCRYPT_EMAIL=mail@domain" \
      --env "GF_SECURITY_ADMIN_USER=admin" \
      --env "GF_SECURITY_ADMIN_PASSWORD=password" \
      --env "GF_USERS_ALLOW_SIGN_UP=false" \
      grafana/grafana
   
## Second VM (set up after the third VM):

- Create the file "prometheus.yml"
    
      nano prometheus.yml
    
- Paste in prometheus.yml
    
      global:
        scrape_interval: 5s
        external_labels:
          monitor: 'node'
      scrape_configs:
        - job_name: 'prometheus'
          static_configs:
            - targets: ['IP_SRV_PROMETHEUS:9090'] ## IP Address of the localhost
        - job_name: 'node-exporter'
          static_configs:
            - targets: ['IP_SRV_NODE_EXPORTER:9100'] ## IP Address of the localhost

- Launch docker (after the third VM)
    
      docker run --net=syntropynet -d -p 9090:9090 --name prometheus -v $PWD/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus:latest
    
## Third VM: 

      docker run --net=x -d -p 9100:9100 --name node-exporter quay.io/prometheus/node-exporter
 
    
## Configuration Grafana

- Connect to https://DuckerDNSDomain address + Add DataSource Prometheus and identify IP_SRV_PROMETHEUS
   
- Import (Create > Import) this Dashboard: https://grafana.com/grafana/dashboards/11074
<center><img src='https://github.com/lorenzo8769/syntropynet-use-cases/blob/mon-1-ui-1/grafana-prometheus-node_exporter-ui/SnapShot%20Node%20Exporter%20with%20Prometheus%20on%20Grafana.png'></center>


__Congratulations, your architecture is up and running ;-)__
