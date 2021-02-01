import * as dbService from './dbService';
import * as mqService from './mqService';
import logger from '../utils/logger';

/**
 * getFibonacci
 * Fetches data from db OR sends message to calculate
 * @params {Number} num - number to calculate
 * @returns {Promise}
 */
export async function getFibonacci(num) {
  const dbResult = await dbService.isFibSaved(num);

  if(!dbResult) {
    logger.info('Fib not saved in db')
    const data = await mqService.sendRPCMessage(num, 'fibqueue');
    await dbService.addResult(num, data);
    return data;
  }
  else {
    logger.info('Found in db, returning instant')
    return dbResult;
  }
}


