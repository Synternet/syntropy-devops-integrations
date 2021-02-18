import express from 'express';
import * as mqClient from './services/mqService';
const isDocker = require('is-docker');

const app = express();

const APP_PORT =
  (process.env.NODE_ENV === 'test' ? process.env.TEST_APP_PORT : process.env.APP_PORT) || process.env.PORT || '3000';
const APP_HOST = process.env.APP_HOST || '0.0.0.0';

mqClient.channelUri = process.env.CHANNEL_URI;
if (isDocker()) {
  mqClient.channelUri = 'amqp://172.20.0.2';
}

// Wait for syntropy to setup network
setTimeout(() => {
  mqClient.setupMqListener();
}, 3000)



export default app;