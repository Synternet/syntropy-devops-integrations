<p align="center">
<img src="images/header.jpg">
</p>

This examples describes how to use the **Syntropy Stack** to create a private IPFS swarm network with 16 nodes. Terraform is used to create the cloud infrastructure across three separate cloud providers. The virtual machines are then configured using Ansible.

```
                      ╔ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ╗

                      ║    ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─      ║
                                                                                                                                                      │
                      ║    │          ┌───────────────────────┐   ┌──────────────────────┬────────────────┬────────────────┬────────────────┐               ║
                                      ├──────────────┐        │   │                      │                │                │                │         │
                      ║    │          ├─────────┐    │        ▼   │                      │                │                │                │               ║
   ┌────────────┐              ┌──────┴─────┐   │    │     ┌────────────┐                │                │                │                │         │
   │            │     ║    │   │   IPFS+    │   │    │     │    IPFS    │                ▼                ▼                ▼                ▼               ║
   │   CLIENT   │─────────────▶│  NGINX +   │   │    │     │ BOOTSTRAP  │         ┌────────────┐   ┌────────────┐   ┌────────────┐   ┌────────────┐   │
   │            │     ║    │   │  GATEWAY   │   │    │     │    NODE    │         │            │   │            │   │            │   │            │         ║
   └────────────┘              └────────────┘   │    │     └────────────┘         │ IPFS NODE  │   │ IPFS NODE  │   │ IPFS NODE  │   │ IPFS NODE  │   │
                      ║    │   172.100.0.0/24   │    │     172.101.0.0/24         │            │   │            │   │            │   │            │         ║
                                                │    │                            └────────────┘   └────────────┘   └────────────┘   └────────────┘   │
                      ║    │                    │    │                            172.102.0.0/24   172.103.0.0/24   172.104.0.0/24   172.105.0.0/24         ║
                                                │    │                                                                                                │
                      ║    │ Digital Ocean      │    │                                                                                                      ║
                            ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┼ ─ ─│─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘
                      ║                         │    │                                                                                                      ║
                                                │    │
                      ║                         │    │  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐     ║
                                                │    │
                      ║                         │    └──┼──────┐   ┌─────────────────────┬────────────────┬────────────────┬────────────────┐         │     ║
                                                │              ▼   │                     │                │                │                │
                      ║                         │       │   ┌────────────┐               │                │                │                │         │     ║
                                                │           │    IPFS    │               ▼                ▼                ▼                ▼
                      ║                         │       │   │ BOOTSTRAP  │        ┌────────────┐   ┌────────────┐   ┌────────────┐   ┌────────────┐   │     ║
                                                │           │    NODE    │        │            │   │            │   │            │   │            │
                      ║                         │       │   └────────────┘        │ IPFS NODE  │   │ IPFS NODE  │   │ IPFS NODE  │   │ IPFS NODE  │   │     ║
                                                │           172.106.0.0/24        │            │   │            │   │            │   │            │
                      ║                         │       │                         └────────────┘   └────────────┘   └────────────┘   └────────────┘   │     ║
                                                │                                 172.107.0.0/24   172.108.0.2/24   172.109.0.2/24   172.110.0.0/24
                      ║                         │       │                                                                                             │     ║
                                                │
                      ║                         │       │  GCP                                                                                        │     ║
                                                │        ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
                      ║                         │                                                                                                           ║
                                                │
                      ║                         │       ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐     ║
                                                │
                      ║                         └───────┼──────┐   ┌─────────────────────┬────────────────┬────────────────┬────────────────┐         │     ║
                                                               │   │                     │                │                │                │
  ┌────────────┐      ║                                 │      ▼   │                     │                │                │                │         │     ║
  │ Bootstrap  │                                            ┌────────────┐               │                │                │                │
  │    Node    │      ║                                 │   │    IPFS    │               ▼                ▼                ▼                ▼         │     ║
  └────────────┘                                            │ BOOTSTRAP  │        ┌────────────┐   ┌────────────┐   ┌────────────┐   ┌────────────┐
                      ║                                 │   │    NODE    │        │            │   │            │   │            │   │            │   │     ║
                                                            └────────────┘        │ IPFS NODE  │   │ IPFS NODE  │   │ IPFS NODE  │   │ IPFS NODE  │
                      ║                                 │   172.111.0.0/24        │            │   │            │   │            │   │            │   │     ║
    Bootstrap                                                                     └────────────┘   └────────────┘   └────────────┘   └────────────┘
       Peer           ║                                 │                         172.112.0.0/24   172.113.0.0/24   172.114.0.0/24   172.15.0.0/24    │     ║
    Connection
  ──────────────▶     ║                                 │  AWS                                                                                        │     ║
                                                         ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
                      ║     SYNTROPY NETWORK                                                                                                                ║
                       ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═
```

# Requirements

- **Syntropy Stack** account and an active Agent Token
- No ports exposed to the internet (except 80 and 443 on the gateway node)
- All services must run in Docker containers
- Ansible >= 2.9.17
- Python >= 3.6
- Terraform 13.6
- Access to the gateway must be restricted to a single node via https

While you can use any cloud provider, the terraform workflow uses AWS, GCP, and Digital Ocea

# Prepare the Syntropy Stack

Install the Syntropy CLI. Docs can be found [here](https://docs.syntropystack.com/docs/syntropy-ctl-installation).

```
pip3 install syntropycli
```

Rename the `sample.secrets.yaml` file to `secrets.yaml` and add your Agent Token (generated via Syntropy UI) to the `api_key` variable.

Next, we need to generate an API Token (not to be confused with your Agent Token). To generate an API Token, install the [Syntropy CLI](https://github.com/SyntropyNet/syntropy-cli).

Generate an API Token by logging in using the CLI:

```
syntropyctl login {syntropy stack user name} { syntropy stack password}
```

Copy the API token and add it to your ENV, for example via your `.bashrc` file. You'll need to add the API URL, as well as your username in password.

```
export SYNTROPY_API_SERVER=https://controller-prod-server.syntropystack.com
export SYNTROPY_API_TOKEN="your_syntropy_api_token"
export SYNTROPY_PASSWORD="your_syntropy_password"
export SYNTROPY_USERNAME="your_syntropy_username"
```

If Ansible is not already installed, you can do so using pip3. Make sure it installs version >= 2.9.17

```
pip3 install ansible
```

Install Syntropy NAC.

```
pip3 install syntropynac
```

Install the Syntropy Ansible Galaxy Collection.

```
ansible-galaxy collection install git@github.com:SyntropyNet/syntropy-ansible-collection.git
```

Navigate to your local ansible directory, for example on Mac OS:

```
cd /Users/{user}/.ansible/collections/ansible_collections/syntropynet/syntropy
```

Install the Python dependencies.

```
pip3 install -U -r requirements.txt
```

# Terraform setup

In order for Terraform to authenticate via your cloud providers, you will need to enable programmatic access to each.

First, rename `terraform.tfvars.example` to `terraform.tfvars`. All references to variables in this section can be found in this file.

**Digital Ocean**

- A personal access token set to the `do_token` variable.
- The location of your SSH private key set to `pvt_key`

**AWS**

- An IAM user for programmatic access with Administrator priviliges (do not use this for production, you should restrict the scope of any production user). Add the credentials to your `~/.aws/credentials` file.

Eg.

```
[syntropy]
aws_access_key_id="your_access_key_here"
aws_secret_access_key="your_secret_access_key_here"
```

- Set the `ssh_public_key` variable to the location of your SSH public key.
- Give the key-pair a name and set `ec2_keypair_name` (this is what it will appear as in AWS)

**GCP**

- Create a project via the GCP console and set the project ID as the `app_project` variable.
- Create a service account ( `APIs & Services > Credentials` ) and download JSON credentials. Place these in the `/auth` directory and set the `gcp_auth_file` variable using the path to your credentials file.
- Enable the Compute Engine API
- Enable the Resource Manager API

# Create the infrastructure

Navigate to the `infrastructure/` directory and initialize the working directory.

```
cd infrastructure
terraform init
```

Create an execution plan.

```
terraform plan
```

Inspect the generated plan and, if everything looks satisfactory, apply the changes. You'' be asked to enter a value of `yes` to execute the plan.

```
terraform apply
```

Login to your various cloud providers to confirm your VMs are running. If you run into any problems with any of the above steps, you can change the log level for Terraform to receive more information using:

```
export TF_LOG=1
```

Terraform generates your Ansible inventory automagically using the `infrastructure/ansible_inventory.tmpl` file and places it at `ansible/inventory`.

# Deploy the IPFS nodes

Navigate to the `ansible/` directory using `cd ../ansible`. First, provision your VMs by installing Docker, Wireguard, and the required Python dependencies.

`ansible-playbook provision_hosts.yaml -i inventory -vv`

Before deploying the IPFS network, you need to generate a swarm key which ensures your network is private and prevents unauthorized peers from joining the network.

On Mac OS (or one of your Ubuntu VMs), use the following command:

```
echo -e "/key/swarm/psk/1.0.0/\n/base16/\n`tr -dc 'a-f0-9' < /dev/urandom | head -c64`" > swarm.key
```

Note, this will create the `swarm.key` file in the current directory. You need to copy this file and place it in both `ansible/roles/launch_ipfs_node/files/swarm.key` and `ansbile/roles/launch_gateway_ipfs_node/files/swarm.key`. Delete the original file. The `swarm.key` will be copied to the nodes during the Ansible deploy. Next, deploy the nodes.

`ansible-playbook deploy_nodes.yaml -i inventory -vv`

Check the Syntropy UI's `End-points` section to ensure your nodes are all online, or use the `syntropyctl get-endpoints` command.

[image goes here]

# Create the Syntropy network

Create the Syntropy Network using the SyntropyNAC command line utility.

```
syntropynac configure-networks networks/ipfs.yml
```

Confirm your network is online via Syntropy UI and that the connections have been made.

![network](images/network.png)

# Bootstrap the IPFS nodes

A private IPFS swarm network needs to provide a list of peers to bootstrapping nodes.

```
ansible-playbook configure_peers.yaml -i inventory -vv
```

(remmove terraform.tfstate to start again and destroy the infra)

Had big problems with v0.14.5 and the digital/ocean provider => downgraded to 0.13.6 and it fixed it
`terraform 0.13upgrade digital_ocean`

gitial ocean tags are a list (not a map), order keeps changing
tags cnt contain periods, so no IPsyes had to do the hack with tags beecause
Ugly hack to convert from set to list => `${sort(droplet_host_numbers[index])[0]}`

# Deploy Nodes

` ansible-playbook deploy_nodes.yaml -i inventory.yaml -vv`

# CReate the network

`syntropynac configure-networks networks/ipfs.yml`

# Bootstrap nodes

`ansible-playbook bootstrap_nodes.yaml -i inventory.yaml -vv`

`docker exec -it gateway ipfs bootstrap list`

# Check the nodes

`docker exec -it gateway ipfs swarm peers`

Terraform uses a directed acyclical graph (DAG) like IPFS.

Webgraphviz.con

remember the IPs are emphemeral

# Resource

https://www.youtube.com/watch?v=kaueUSiDrc0

https://www.youtube.com/watch?v=5Uj6uR3fp-U

https://gmusumeci.medium.com/getting-started-with-terraform-and-google-cloud-platform-gcp-e718017376d1

# Digital Ocean

Create an access token: https://www.digitalocean.com/docs/apis-clis/api/create-personal-access-token/

Add it to your env as `DO_PAT`

# Google Cloud

Creaeeette srervicee acc with Compute Admin Role

Log in to the Google Cloud Console and create a new project.
Then go to the IAM & admin menu and select the Service account option. Create a new service account and grant the compute admin role. Click the Create Key button to generate a JSON file with a key.
Download the generated JSON file and save it to the directory of your project.
If you need more information about how to create the JSON file for authentication https://cloud.google.com/iam/docs/creating-managing-service-account-keys
Enable the following APIs on the project where your VPC resides:
Compute Engine API → https://console.cloud.google.com/apis/library/compute.googleapis.com
Cloud Resource Manager API → https://console.cloud.google.com/apis/library/cloudresourcemanager.googleapis.com

# sequeencee

- run `terraform plan`
- run `terraform apply`
- run `ansible-playbook provision_hosts.yaml -i inventory -vv`
- copy swarm.key into roles
- run `ansible-playbook deploy_nodes.yaml -i inventory -vv`

- run `syntropynac configure-networks networks/ipfs.yml`

**We add the ansible cfg file to prevent host key checking**
