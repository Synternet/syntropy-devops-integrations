# Syntropy based monitoring stack

These ansible-playbooks for automated Samba AD domain controller, clients and Syntropy network deployment. It allows to connect remote domain controller and clients in a secure way without any port forwards, routing, firewalling etc. These playbooks allow to automatically join connect to Syntropy network multiple domain clients depending on subnet address space.

All the network traffic is being handled by Syntropy Agent connections - secure encrypted tunnels based on Wireguard. This network scheme is being managed by Syntropy Platform, which allows easily device connections and networks both using CLI and WEB UI.

Samba AD and Syntropy agents are deployed as docker containers, while domain clients are using samba and winbind services to join newly deployed domain. The connection between VMs is maintained by Syntropy Agents.

<center><img src="images/diagram.png"></center>


## What is Syntropy?

Syntropy stack is software which lets you to easily establish VPN connections between remote endpoints, implement network-as-a-code approach and to avoid complex and inefficient network firewall and routing setups.

## Requirements

- Debian/Ubuntu based distro and dependencies installed and ansible server configured. 
- You will also need to register for Syntropy account here: https://platform.syntropystack.com
- Wireguard kernel module is required if you are running kernel older than 5.6. More details here: https://docs.syntropystack.com/docs/start-syntropy-agent
## Dependencies

These are required for Syntropy network management via CLI:

```
apt install ansible
apt install python3
apt install python3-pip
pip install git+https://github.com/SyntropyNet/syntropy-cli#egg=syntropycli
```

## How to run

Get it running by 3 steps explained below:

1) Register for Syntropy account then get API key and API token
2) Update variables
3) Run playbooks
### Step1 - get API token and API key
You can create your API key at: https://platform.syntropystack.com

In order to get temporary API token:
```
git cexport SYNTROPY_API_SERVER=https://controller-prod-server.syntropystack.com
syntropyctl login your@account.com
Password: **********lone https://github.com/jpacekajus/syntropy-grafana-prometheus-node-exporter.git
```

### Step2 - update variables

Update the variables in main.yml:

#### Deploy Samba task:
cloud provider - cloud provider for samba server check your ID here
api_key -use API key for Syntropy Platform web UI
domain - your new domain name in uppercase
domainpass - your domain admin password
workgroup - recomended to be subdomain of domain in uppercase
dns_forwarder - where to forward DNS queries outside of domain

#### Deploy Syntropy agents task:
cloud provider - cloud provider for domain client servers, check your ID here
api_key - use API key for Syntropy Platform web UI (can be same)
syntropy_network_name - choose a name for your Syntropy network

#### Setup Syntropy network:
api_token - API token string you got form prerequisites step 7

#### Setup domain client task:
dc_ip - IP address of domain controller (should be same as in Deploy Samba task)
domain - your new domain name in uppercase
domainpass - your domain admin password (should be same as in Deploy Samba task)
workgroup - recomended to be subdomain of domain in uppercase(should be same as in Deploy Samba task)
allowed_group_name - AD group name which will have acess to newly joined domain client servers

### Step3 - run playbooks
Just run this command to run playbooks:
```
ansible-playbook main.yml
```

Visit the Platform WEB UI to check you network: 

https://platform.syntropystack.com

That's it! You have deployed your new Samba AD domain and joined clients by using secure Syntropy network.
