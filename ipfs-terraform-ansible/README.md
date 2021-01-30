# Deploy Nodes

` ansible-playbook deploy_nodes.yaml -i inventory.yaml -vv`

# CReate the network

`syntropynac configure-networks networks/ipfs.yml`

# Bootstrap nodes

`ansible-playbook bootstrap_nodes.yaml -i inventory.yaml -vv`

`docker exec -it gateway ipfs bootstrap list`

# Check the nodes

`docker exec -it gateway ipfs swarm peers`
