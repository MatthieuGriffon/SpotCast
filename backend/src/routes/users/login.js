import express from 'express';
import { loginUser, validateLogin } from '../../controllers/users/userLoginController.js';
import {generalLimiter } from '../../middlewares/rateLimiter.js';

const router = express.Router();

// Route pour le login utilisateur
router.post('/login', generalLimiter, validateLogin, loginUser);

export default router;
