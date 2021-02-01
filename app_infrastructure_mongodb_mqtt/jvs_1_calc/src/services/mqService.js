import * as amqp from 'amqplib';
import logger from '../utils/logger';

const q = 'fibqueue';
let channel = null;
export let channelUri = '';

/**
 * Create amqp channel
 */
export async function createPublisherChannel(url) {
  const open = await amqp.connect(url);
  channel = await open.createChannel();
}

/**
 * Send RPC message to waiting queue and return promise object when
 * event has been emitted from the "consume" function
 * @params {Object} channel - amqp channel
 * @params {String} message - message to send to consumer
 * @params {String} rpcQueue - name of the queue where message will be sent to
 * @returns {Promise} - return msg that send back from consumer
 */
export async function setupMqListener() {
    if(!channel) {
        await createPublisherChannel(this.channelUri);
    }

    channel.assertQueue(q, { durable: true });
    channel.prefetch(1);
    logger.info(`Awaiting RPC requests ..`);

    channel.consume(q, msg => {
        console.log(msg.content.toString())
        const n = parseInt(msg.content.toString());
        logger.info(`Calculating fibonacci for ${n}`);
        const fib = fibonacci(n);
       
        // to send object as a message,
        // you have to call JSON.stringify
        const r = JSON.stringify({
          result: fib
        });
        logger.info(`Returning result (${fib})`);
        channel.sendToQueue(msg.properties.replyTo, Buffer.from(r.toString()),
          { correlationId: msg.properties.correlationId });
        channel.ack(msg);
      })
};

function fibonacci(number) {

	if (number < 1)
		return 0;

	if (number <= 2)
		return 1;

   return fibonacci(number - 1) + fibonacci(number - 2);
}