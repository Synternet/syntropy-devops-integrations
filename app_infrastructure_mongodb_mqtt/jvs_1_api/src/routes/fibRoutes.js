import { Router } from 'express';

import * as fibController from '../controllers/fib';

const router = Router();

/**
 * GET /api/fib/:id
 */
 router.get('/:id', fibController.getFibonacci);

export default router;
