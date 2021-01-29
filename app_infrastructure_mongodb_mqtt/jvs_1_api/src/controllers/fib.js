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

// /**
//  * Get a user by its id.
//  *
//  * @param {Object} req
//  * @param {Object} res
//  * @param {Function} next
//  */
// export function fetchById(req, res, next) {
//   userService
//     .getUser(req.params.id)
//     .then(data => res.json({ data }))
//     .catch(err => next(err));
// }

// /**
//  * Create a new user.
//  *
//  * @param {Object} req
//  * @param {Object} res
//  * @param {Function} next
//  */
// export function create(req, res, next) {
//   userService
//     .createUser(req.body)
//     .then(data => res.status(HttpStatus.CREATED).json({ data }))
//     .catch(err => next(err));
// }

// /**
//  * Update a user.
//  *
//  * @param {Object} req
//  * @param {Object} res
//  * @param {Function} next
//  */
// export function update(req, res, next) {
//   userService
//     .updateUser(req.params.id, req.body)
//     .then(data => res.json({ data }))
//     .catch(err => next(err));
// }

// /**
//  * Delete a user.
//  *
//  * @param {Object} req
//  * @param {Object} res
//  * @param {Function} next
//  */
// export function deleteUser(req, res, next) {
//   userService
//     .deleteUser(req.params.id)
//     .then(data => res.status(HttpStatus.NO_CONTENT).json({ data }))
//     .catch(err => next(err));
// }
