# Terraform

Create AWS credentials

export TF_LOG=1

`terraform init` installs modules

`terraform plan`

deploy: `terraform apply`

`export TF_LOG=1`

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

# Digital OCean

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
