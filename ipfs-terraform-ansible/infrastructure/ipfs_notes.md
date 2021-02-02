`ipfs swarm peers`: list peers in network

`curl http://172.20.0.2:5001/api/v0/swarm/peers`

//TODO: Might have to set API url to docker container url

it will only call `ipfs init` if the `data/` folder is empty

`ipfs id` get information about the container, including ID:

check for bootstrap list:
`docker exec -it ipfs0 ipfs bootstrap list`

ipfs0:
12D3KooWAxHzCRWid3d6Y8pauev9ofouKMx3TzmBdFcJw2Mjg6ep

ipfs1:
12D3KooWLBpKeeTnRy9y2ycWTk5XBMgMbRyZEie12JVq9HDVCvWc

ipfs2:
12D3KooWE6ooUvVizQ3M5fpGqXZBXtTQipnsPZVuTr7Nv4AkuxTA

https://docs.ipfs.io/how-to/modify-bootstrap-list/
Remove all the bootstrap nodes:
`ipfs bootstrap rm --all`
// TODO: find a way to do this via an eenv

Eg.
ipfs0: ipfs bootstrap add /ip4/172.20.0.2/tcp/4001/p2p/12D3KooWAxHzCRWid3d6Y8pauev9ofouKMx3TzmBdFcJw2Mjg6ep

ipfs1: ipfs bootstrap add /ip4/172.21.0.2/tcp/4001/p2p/12D3KooWLBpKeeTnRy9y2ycWTk5XBMgMbRyZEie12JVq9HDVCvWc

ipfs2: ipfs bootstrap add /ip4/172.22.0.2/tcp/4001/p2p/12D3KooWE6ooUvVizQ3M5fpGqXZBXtTQipnsPZVuTr7Nv4AkuxTA

What are these envs?
environment: - IPFS_PROFILE=server - IPFS_PATH=/ipfsdata

This looks interesting: `docker-compose exec ipfs ipfs config Addresses.Swarm '["/ip4/0.0.0.0/tcp/4001", "/ip4/0.0.0.0/tcp/8081/ws", "/ip6/::/tcp/4001"]' --json`

You can store files in temp and add them with `/export`

# for files stored in /tmp/ipfs-docker-staging

    sudo docker exec ipfs-node ipfs add /export/tet.new

// TODO: test that the mounting actually works

`ipfs add text.txt`
hash resturned: QmYi7wrRFKVCcTB56A6Pep2j31Q5mHfmmu21RzHXu25RVR

To just get the peer ID:
` docker exec -it ipfs1 ipfs id -f="<id>\n"`

// TODO: how to programmatically bootstrap the nodes, might be able to use JS: https://github.com/ipfs/js-ipfs

Can access url via:http://134.209.171.54:8080/ipfs/QmYi7wrRFKVCcTB56A6Pep2j31Q5mHfmmu21RzHXu25RVR
note, must enable port 8080 in firewall

/home # ipfs add -w testDir/testInDir.txt
added QmbL1YqFVb7d23HrrooLLKQckoPreF9ejRyDjBppxJe4zT testInDir.t

can explore the folder using : `http://134.209.171.54:8080/ipfs/<folder_CID>`

---

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
