import express from 'express';
import * as mqClient from './services/mqService';
const isDocker = require('is-docker');

const app = express();

const APP_PORT =
  (process.env.NODE_ENV === 'test' ? process.env.TEST_APP_PORT : process.env.APP_PORT) || process.env.PORT || '3000';
const APP_HOST = process.env.APP_HOST || '0.0.0.0';

mqClient.channelUri = process.env.CHANNEL_URI;
if (isDocker()) {
  mqClient.channelUri = 'amqp://rabbit';
}
mqClient.setupMqListener();


export default app;