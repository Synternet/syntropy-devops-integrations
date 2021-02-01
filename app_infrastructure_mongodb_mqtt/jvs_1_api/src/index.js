import './env';
import express from 'express';
import bodyParser from 'body-parser';
import * as Sentry from '@sentry/node';

import routes from './routes';
import json from './middlewares/json';
import logger, { logStream } from './utils/logger';
import * as errorHandler from './middlewares/errorHandler';
import * as dbService from './services/dbService';
import * as mqClient from './services/mqService';
const isDocker = require('is-docker');


// Initialize Sentry
// https://docs.sentry.io/platforms/node/express/
Sentry.init({ dsn: process.env.SENTRY_DSN });

const app = express();

const APP_PORT =
  (process.env.NODE_ENV === 'test' ? process.env.TEST_APP_PORT : process.env.APP_PORT) || process.env.PORT || '3000';
const APP_HOST = process.env.APP_HOST || '0.0.0.0';

app.set('port', APP_PORT);
app.set('host', APP_HOST);

app.locals.title = process.env.APP_NAME;
app.locals.version = process.env.APP_VERSION;

// This request handler must be the first middleware on the app
app.use(Sentry.Handlers.requestHandler());

// Set up mongoose connection
let mongoHOST = process.env.DB_HOST;
const mongoPORT = process.env.DB_PORT;
const mongoNAME = process.env.DB_NAME;

mqClient.channelUri = process.env.CHANNEL_URI;
if (isDocker()) {
  mongoHOST = 'mongo';
  mqClient.channelUri = 'amqp://rabbit';
}

const mongoConnection = `mongodb://${mongoHOST}:${mongoPORT}/${mongoNAME}`;
dbService.setupMongo(mongoConnection);

app.use(bodyParser.json());
app.use(errorHandler.bodyParser);
app.use(json);

// API Routes
app.use('/api', routes);

// This error handler must be before any other error middleware
app.use(Sentry.Handlers.errorHandler());

// Error Middleware
app.use(errorHandler.genericErrorHandler);
app.use(errorHandler.methodNotAllowed);

app.listen(app.get('port'), app.get('host'), () => {
  logger.info(`Server started at http://${app.get('host')}:${app.get('port')}/api`);
});

// Catch unhandled rejections
process.on('unhandledRejection', (err) => {
  logger.error('Unhandled rejection', err);

  try {
    Sentry.captureException(err);
  } catch (err) {
    logger.error('Sentry error', err);
  } finally {
    process.exit(1);
  }
});

// Catch uncaught exceptions
process.on('uncaughtException', (err) => {
  logger.error('Uncaught exception', err);

  try {
    Sentry.captureException(err);
  } catch (err) {
    logger.error('Sentry error', err);
  } finally {
    process.exit(1);
  }
});

export default app;
