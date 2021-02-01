import logger from '../utils/logger';
import * as amqp from 'amqplib';

const EventEmitter = require('events');
let channel = null;
export let channelUri = '';


// this queue name will be attached to "replyTo" property on producer's message,
// and the consumer will use it to know which queue to the response back to the producer
const REPLY_QUEUE = 'amq.rabbitmq.reply-to';

// this function will be used to generate random string to use as a correlation ID
function generateUuid() {
    return Math.random().toString() +
           Math.random().toString() +
           Math.random().toString();
  }

/**
 * Create amqp channel
 */
export async function createPublisherChannel(url) {
  const open = await amqp.connect(url);
  channel = await open.createChannel();
  channel.responseEmitter = new EventEmitter();
  channel.responseEmitter.setMaxListeners(0);
  channel.consume(REPLY_QUEUE, msg => channel.responseEmitter.emit(msg.properties.correlationId, msg.content), { noAck: true });
}

/**
 * Send RPC message to waiting queue and return promise object when
 * event has been emitted from the "consume" function
 * @params {String} message - message to send to consumer
 * @params {String} rpcQueue - name of the queue where message will be sent to
 * @returns {Promise} - return msg that send back from consumer
 */
export async function sendRPCMessage(message, rpcQueue) {
  if(!channel) {
    await createPublisherChannel(this.channelUri);
  }

  return new Promise((resolve) => {
    // unique random string
    const correlationId = generateUuid();

    channel.responseEmitter.once(correlationId, (buffer) => {
      const data = buffer.toString();
      resolve(JSON.parse(data).result);
    });
    logger.info(`Number (${message}) sent to calculation, awaiting ..`);
    channel.sendToQueue(rpcQueue, Buffer.from(message), { correlationId, replyTo: REPLY_QUEUE });
  })

};


