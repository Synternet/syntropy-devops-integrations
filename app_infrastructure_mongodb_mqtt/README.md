
> JavaScript app infrastructure with Express.js, MongoDB and RabbitMQ

### Prerequisites

- [Node.js](https://yarnpkg.com/en/docs/install)
- [Yarn](https://yarnpkg.com/en/docs/install)
- [NPM](https://docs.npmjs.com/getting-started/installing-node)

- [Docker](https://www.docker.com/)
- [MongoDB](https://hub.docker.com/_/mongo)
- [RabbitMQ](https://hub.docker.com/_/rabbitmq)
 
### Content
- The folder "jvs_1_api" contains the webserver with an exposed endpoint for fibonnaci
- The folder "jvs_1_calc" contains the service for calculation

### Setup (local testing)

Clone the repository

    $ git clone https://github.com/SyntropyNet/syntropy-devops-integrations.git

##### Open your favorite terminal
Start RabbitMQ

    $ docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3-management

Start MongoDB

    $ docker run --rm -it  -p 27017:27017/tcp mongo:latest


### API
    $ cd app_infrastructure_mongodb_mqtt/jvs_1_api
    $ yarn   # or npm install

    $ yarn start:dev (For development)

### Calc
    $ cd app_infrastructure_mongodb_mqtt/jvs_1_calc
    $ yarn   # or npm install

    $ yarn start:dev (For development)

## Using Docker

### Using docker-compose

Use [docker-compose](https://docs.docker.com/compose/) to quickly bring up a working stack with all four services(mongoDb, rabbitMQ, api and calculator-service)

Specific configuration is found in the `.env`-file located at the root of the api/calculator projects.

Bring up stack,

    $ docker-compose up

Wait for all services start, then navigate to http://localhost:8848/api to verify application is running from docker.

Bring down stack,

    $ docker-compose down

The api contains a single endpoint, and is reachable at http://localhost:8848/api/fib/1, where 1 is the number to be calculated


