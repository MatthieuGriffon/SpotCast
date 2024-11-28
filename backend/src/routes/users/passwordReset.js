import express from 'express';
import { requestPasswordReset, resetPassword } from '../../controllers/users/userPasswordResetController.js';
import { passwordResetLimiter } from '../../middlewares/rateLimiter.js';

const router = express.Router();

// Appliquer le middleware de limitation sur les endpoints sensibles
router.post('/request', passwordResetLimiter, requestPasswordReset);
router.post('/reset', passwordResetLimiter, resetPassword);

export default router;
