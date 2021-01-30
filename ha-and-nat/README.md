# SyntropyStack - Connect to a Home Assistant service behind NAT from your computer


In this tutorial, we will be creating a network with two nodes: GCP virtual machine (running Home Assistant) and home computer. To deploy our network, we will be using Syntropy Stack.

## Create VM inside a NAT network
First of all, we need to create a new GCP NAT network and initialize a virtual machine instance inside it. Since the installation process is beyond this tutorial, I will provide a link on how to achieve this instalation.

<a href="https://cloud.google.com/nat/docs/overview" target="_blank">Cloud NAT overview | Google Cloud</a>

## Start Syntropy Agent with Docker on GCP VM
```
sudo docker run - network="host" - restart=on-failure:10 \
 - cap-add=NET_ADMIN \
 - cap-add=SYS_MODULE -v /var/run/docker.sock:/var/run/docker.sock:ro \
 - device /dev/net/tun:/dev/net/tun - name=syntropy-agent \
-e SYNTROPY_NETWORK_API=CHANGE ME \
-e SYNTROPY_PROVIDER=CHANGE ME \
-e SYNTROPY_LOG_LEVEL=CHANGE ME\
-e SYNTROPY_API_KEY=CHANGE ME 
-d syntropynet/agent:stable
```
Once deployed, our VM will appear on the Syntropy Stack interface thanks to the agent launched with Docker.

<center><img src="https://github.com/Paulius0112/syntropy-devops-integrations/blob/master/ha-and-nat/images/endpoint.png"></center>

## The creation of subnet
It is important to distinguish VM and Services, therefore it is necessary to mount them on different IP address plans. Therefore, a network with dedicated subnet is created using Docker, which will be later assigned for our Home Assistant service.
```
sudo docker network create --subnet 10.44.0.0/16 syntropynet
```

## Launch Home Assistant on VM using Docker
Home Assistant service can be launched following the tutorial below from the official Home Assistant website.

<a href="https://www.home-assistant.io/docs/installation/docker/">Installation on Docker</a>

One thing to notice is that we must specify that Home Assistant container must operate in the previously created network. The final command will be:
```
docker run -d --name="home-assistant" --network=syntropynet --restart on-failure -v CHANGEME:/config -e "TZ=CHANGE ME" homeassistant/home-assistant
```

We can configure that our service is running by going back to Syntropy Stack UI and listing the services launched on our GCP VM

<center><img src="https://github.com/Paulius0112/syntropy-devops-integrations/blob/master/ha-and-nat/images/end-service.png"></center>

## Launch Syntropy Stack agent on your local computer (Linux OS)
```
sudo docker run - network="host" - restart=on-failure:10 \
 - cap-add=NET_ADMIN \
 - cap-add=SYS_MODULE -v /var/run/docker.sock:/var/run/docker.sock:ro \
 - device /dev/net/tun:/dev/net/tun - name=syntropy-agent \
-e SYNTROPY_NETWORK_API=CHANGE ME \
-e SYNTROPY_LOG_LEVEL=CHANGE ME\
-e SYNTROPY_API_KEY=CHANGE ME 
-d syntropynet/agent:stable
```

Our local computer should appear in the Syntropy Stack UI.

<center><img src="https://github.com/Paulius0112/syntropy-devops-integrations/blob/master/ha-and-nat/images/two-services.png"></center>

## Create your Network SyntropyStack

<center><img src="https://github.com/Paulius0112/syntropy-devops-integrations/blob/master/ha-and-nat/images/topology.png"></center>

SyntropyStack UI allows us to connect these devices with one click. An encrypted Tunnel is then built. Later, we must connect these services to allow them to communicate with each other.

<center><img src="https://github.com/Paulius0112/syntropy-devops-integrations/blob/master/ha-and-nat/images/connected-topology.png"></center>

<center><img src='https://github.com/Paulius0112/syntropy-devops-integrations/blob/master/ha-and-nat/images/connected-network.png'></center>

## Home Assistant

Now that all services are communicating with each other, we should be able to access Home Assistant main page by typing the address of our domain name and specifying the default port of Home Assistant
```http://domain_name:8123/```

<center><img src="https://github.com/Paulius0112/syntropy-devops-integrations/blob/master/ha-and-nat/images/ha.png"></center>




