# Syntropy based monitoring stack

These ansible-playbooks and related files are for semi-automated monitoring stack (Grafana, Prometheus, node-exporter) deployment utilizing simplicity of network configuration provided by Syntropy agent and command line utilities.

The best part is that these playbooks will allow you to easily scale your monitoring setup for multiple remote node-exporters by automatically creating required non-overlapping docker networks and auto-generating Prometheus scrape config targets (based on your node-exporter ansible hosts in the inventory). It will also provisions Grafana datasource and dashboards to be used with Prometheus and node-exporter. Therefore you can begin using this monitoring stack out of the box!

## What is Syntropy?

Syntropy stack is software which lets you to easily establish VPN connections between remote endpoints, implement network-as-a-code approach and to avoid complex and inefficient network firewall and routing setups.


## Requirements

Debian/Ubuntu based distro and dependencies installed and ansible server configured. You will also need to register for Syntropy account here:

https://platform.syntropystack.com

## Dependencies

These are required for Syntropy network management via CLI:

```
apt install ansible
apt install python3
apt install python3-pip
pip install git+https://github.com/SyntropyNet/syntropy-cli#egg=syntropycli
pip install git+https://github.com/SyntropyNet/syntropy-nac#egg=syntropynac
```

## How to run

Get it running by 3 steps explained below:

1) Prepare the code and variables
2) Run asible-playbook
3) Setup Syntropy Network

### Step1 - code preparation

Simply clone the code repository to your ansible server:
```
git clone https://github.com/jpacekajus/syntropy-grafana-prometheus-node-exporter.git
```
Update your inventory file accordingly:
```
cat /etc/ansible/hosts

[exporter_nodes]
exporter1
exporter2
exporterN

[prometheus_nodes]
prometheus1

[web_nodes]
grafana1

```
Update the variables in main.yml at the top directory (if node-exporter subnet beggining is changed, then change roles/prometheus/templates/prometheus.j2 accordingly):
```
...
- name: Deploy Grafana
  become: true
  hosts: web_nodes
  vars:
    subnet: 172.1.0.0/24
    prometheus_ip: 172.2.0.2
    cloud_provider: '3
    api_key: MyAPIKey
    domain: 'grafana.mydomain.com'
    email: 'my@email.com'
...
```
### Step2 - running ansible playbook

Run the playbook:
```
ansible-playbook main.yaml
```
### Step3 - setting up Syntropy network

Login to Syntropy using CLI

```
export SYNTROPY_API_SERVER=https://controller-prod-server.syntropystack.com
syntropyctl login your@account.com
Password: **********
```
Save the token:
```
export SYNTROPY_API_TOKEN=QWERTYUIOPASLDFDNGGMWJRDNSKFHSKKSNNS
```
Get endpoint details:
```
syntropyctl get-endpoints
```
Update (ids, network and endpoint names) the network file to represent your Syntropy Network configuration:
```
cat networks/grafana-prom-exporter.yml

connections:
  exporter1:
    connect_to:
      prometheus1:
        id: 625
        services: [prometheus1]
        type: endpoint
    id: 624
    services: [node_exporter]
    state: present
    type: endpoint
  grafana1:
    connect_to:
      prometheus1:
        id: 625
        services: [prometheus1]
        type: endpoint
    id: 623
    services: [grafana]
    state: present
    type: endpoint
  prometheus1:
    connect_to:
      exporter2:
        id: 676
        services: [node_exporter]
        type: endpoint
    id: 625
    services: [prometheus1]
    state: present
    type: endpoint
id: 339
name: monitoring
state: present
topology: P2P

```
Use Syntropy NAC to configure the network for you:
```
syntropynac configure-networks networks/grafana-prom-exporter.yml
```

Visit the Platform WEB UI to check you network: 

https://platform.syntropystack.com

That's it! You can try out your newly created monitoring stack which is based on secure and fast Syntropy network! Just visit the domain URL you provided as variable in main.yml!
