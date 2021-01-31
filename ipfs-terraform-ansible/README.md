# Terraform

Create AWS credentials

export TF_LOG=1

`terraform init` installs modules

`terraform plan`

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
