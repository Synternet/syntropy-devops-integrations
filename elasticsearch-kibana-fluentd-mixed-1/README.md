<p align="center">
<img src="">
</p>

This example describes how to use the **Syntropy Stack** to create a logging network that spans three separate VMs spread out across different cloud providers. We'll be using an EFK (Elasicsearch, FluentD, and Kibana) stack. [FluentD]() serves as a unified logging layer, while [ElasticSearch]() provides an interface for searching through the logs. A [Kibana]() service sitting behind [Nginx]() provides a dashboard for visualizing our log data. Each service will be created using an Ansible playbook and the network will be created using the Syntropy NAC (Network As Code) command line utility.

```
┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐

│                                                                                                                     │

│                                                                                                                     │
       ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─                                               ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
│                               │                                                                       │             │
       │                                                                       │
│                               │                                                  ┌────────────────┐   │             │
       │                                                                       │   │    FluentD     │
│                               │                                                  │                │   │             │
       │                                                                       │   └────────────────┘
│                               │                                                                       │             │
       │                                                                       │   ┌────────────────┐
│                               │                                                  │    Syntropy    │   │             │
       │                                                                       │   │     Agent      │
│                               │                                                  └────────────────┘   │             │
       │                                                                       │
│       ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘                                               ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘             │

│                                                                                                                     │

│                                           ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─                                                 │
                                                                     │
│                                           │                                                                         │
                                                ┌────────────────┐   │
│                                           │   │ ElasticSearch  │                                                    │
                                                │                │   │
│                                           │   └────────────────┘                                                    │
                                                                     │
│                                           │   ┌────────────────┐                                                    │
                                                │    Syntropy    │   │
│                                           │   │     Agent      │                                                    │
                                                └────────────────┘   │
│                                           │                                                                         │
                                             ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘
│                                                                                                                     │

│                                                                                                                     │

│                                                                                                                     │

│                                                                                                                     │
                                            ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
│                                               ┌────────────────┐   │                                                │
                                            │   │    Syntropy    │
│                                               │     Agent      │   │                                                │
                                            │   └────────────────┘
│                                               ┌────────────────┐   │                                                │
                                            │   │     Kibana     │
│                                               │                │   │                                                │
                                            │   └────────────────┘
│                                               ┌────────────────┐   │                                                │
                                            │   │     Nginx      │
│                                               │                │   │                                                │
                                            │   └────────────────┘
│                                            ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘                                                │

│                                                                                                                     │

│                                                                                                                     │

│                                                                                                   Syntropy Network  │
 ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─






                                                ┌───────────────┐
                                                │               │
                                                │    Client     │
                                                │               │
                                                └───────────────┘
```

# Requirements

- There must be no ports exposed to the internet (except Nginx 443 with SSL)
- All services must run in Docker containers.
- All connections between services must be created using Syntropy Stack.
- You must create a Docker network (name: syntropynet) on each node and assign subnets, which can’t overlap.
- All services must run in syntropynet Docker network.
- Ansible needs to be installed on your Control node (your local machine or whatever machine you will run the playbooks on)
- Python >= 3.6

# Create the network

`syntropynac configure-networks networks/LOG3.yml`

# NOTES

If you don’t want to expose port 9200 and instead use a reverse proxy, replace 9200:9200 with 127.0.0.1:9200:9200 in the docker-compose.yml file. Elasticsearch will then only be accessible from the host machine itself.

Test that elastic search is running
`curl -X GET "localhost:9200/_cat/nodes?v=true&pretty"`

Elastic Searc hthis sets heap size: ` ES_JAVA_OPTS: "-Xms512m -Xmx512m"`

New VM: needed to add user to group

> sudo gpasswd -a $USER docker
> newgrp docker

Need to create an htpassword for nginx proxy:

https://www.web2generators.com/apache-tools/htpasswd-generator

On AWS, had to assign an elastic IP to make it publicly accessible: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html#eip-basics

kibana.yaml versus kibana.yml (not overwriting correctly)

Order of the services matters.

Experienced some memory issues with GCP

EFK Stack: https://www.digitalocean.com/community/tutorials/how-to-set-up-an-elasticsearch-fluentd-and-kibana-efk-logging-stack-on-kubernetes

htpasswd is stored in secrets.
