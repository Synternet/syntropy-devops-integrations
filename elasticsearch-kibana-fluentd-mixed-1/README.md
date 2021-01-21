<p align="center">
<img src="">
</p>

This example describes how to use the **Syntropy Stack** to create a logging network that spans three separate VMs spread out across different cloud providers. [FluentD]() serves as a unified logging layer, while [ElasticSearch]() provides an interface for searching through the logs. A [Kibana]() service sitting behind [Nginx]() provides a dashboard for visualizing our log data. Each service will be created using an Ansible playbook and the network will be created using the Syntropy NAC (Network As Code) command line utility.

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

# NOTES

If you don’t want to expose port 9200 and instead use a reverse proxy, replace 9200:9200 with 127.0.0.1:9200:9200 in the docker-compose.yml file. Elasticsearch will then only be accessible from the host machine itself.

Test that elastic search is running
`curl -X GET "localhost:9200/_cat/nodes?v=true&pretty"`

Elastic Searc hthis sets heap size: ` ES_JAVA_OPTS: "-Xms512m -Xmx512m"`

New VM: needed to add user to group

> sudo gpasswd -a $USER docker
> newgrp docker
