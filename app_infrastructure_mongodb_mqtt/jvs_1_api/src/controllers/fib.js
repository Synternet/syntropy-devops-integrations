import HttpStatus from 'http-status-codes';

import * as fibService from '../services/fibService';

/**
 * Get fib of number
 *
 * @param {Object} req
 * @param {Object} res
 * @param {Function} next
 */
export async function getFibonacci(req, res, next) {

  try {
    const result = await fibService
      .getFibonacci(req.params.id);

    return res.json({result});
  }
  catch(err) {
    next(err);
  }
}
