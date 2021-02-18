
> Using the Syntropy stack to create a 4-node network. This project consists of two Express.js javascript nodes, a MongoDB and a RabbitMQ instance.
> There will be a fibonacci-endpoint on the api-service. This function will forward requests to another service/server, which will calculate and return the result.
> We will be hosting these instances as docker containers on 4 different servers, building their network with the Syntropy stack UI.

### Prerequisites

- [Syntropy stack Api-Key](https://docs.syntropystack.com/docs/what-is-syntropy-stack)
- [4 remote servers](digitalocean.com)
- [WireGuard on all servers](https://www.wireguard.com/install/)
- [Node.js](https://yarnpkg.com/en/docs/install)
- [Yarn](https://yarnpkg.com/en/docs/install)
- [NPM](https://docs.npmjs.com/getting-started/installing-node)

- [Docker](https://www.docker.com/)
- [MongoDB](https://hub.docker.com/_/mongo)
- [RabbitMQ](https://hub.docker.com/_/rabbitmq)
 
### Content
- The folder "jvs_1_api" contains the webserver with an exposed endpoint for fibonnaci
- The folder "jvs_1_calc" contains the service for calculation
- "jvs_1_mongo" contains a docker-compose.yml for spinning up mongoDB
- "jvs_1_rabbit" contains a docker-compose.yml for spinning up rabbitMQ

### Setup

Clone the repository

    $ git clone https://github.com/SyntropyNet/syntropy-devops-integrations.git
This project is located at the "app_infrastructure_mongodb_mqtt"-folder.

##### MongoDB
Enter the /jvs_1_mongo folder and edit/transfer the docker-compose.yml to the first server.

    $ scp docker-compose.yml user@server:/opt/yourfolder
    
###### Ssh into the server and run docker compose.
    $ docker-compose up
This will run the syntropy-agent and mongoDB.

##### RabbitMQ
Enter the /jvs_1_rabbit folder and edit/transfer the docker-compose.yml to the second server.

    $ scp docker-compose.yml user@server:/opt/yourfolder
    
###### Ssh into the server and run docker compose.
    $ docker-compose up

This will run the syntropy-agent and RabbitMQ.

##### Calculator service
Enter the /jvs_1_calc folder and edit the docker-compose.yml.
Transfer this folder to your third server, or use the provided transfer.sh-file.

    $ chmod +x transfer.sh
    $ ./transfer.sh user@thirdserver:/opt/yourfolder

###### Ssh into the server and run docker compose.
    $ docker-compose up

This will run the syntropy-agent and the calculator service. Notice that this will fail, due to not being able to connect to rabbitMQ. We will fix this shortly.

##### Api service
Enter the /jvs_1_api folder and edit the docker-compose.yml.
Transfer this folder to your fourth server, or use the provided transfer.sh-file.

    $ chmod +x transfer.sh
    $ ./transfer.sh user@fourthserver:/opt/yourfolder

###### Ssh into the server and run docker compose.
    $ docker-compose up

This will run the syntropy-agent and the api service. Notice that this will fail, due to not being able to connect to mongoDb. We will fix this shortly.


## Network Setup
### Using the Syntropy UI

Navigate to https://platform.syntropystack.com/ and login.

##### Networks tab:
Tap the +icon, and enter a network name: i.e 'jvs_1_net'

##### All your services are now presented in the network-map: 
Tap the "api"-service
... and check the mongoDB and rabbitMQ-checkbox.
Click "apply changes".

Tap the "calc"-service
... and check the rabbitMQ-checkbox.
Click "apply changes".

##### Connections have now been made between your services. 
To finish the setup, click the "back"-button to see the three connections.
Tap to open all three accordions, and make sure all checkmarks are checked beside the services.
Click "apply changes".

##### Your network is now up and running.
Restart the api and calc services on server 3 and 4.
Ctrl-C and run the docker-compose up.


On server 4: The api contains a single endpoint, and is reachable at http://localhost:8848/api/fib/1, where 1 is the number to be calculated


