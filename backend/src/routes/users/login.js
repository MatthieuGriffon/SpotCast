import express from 'express';
import { loginUser, validateLogin, refreshTokenHandler, logoutHandler } from '../../controllers/users/userLoginController.js';
import {generalLimiter } from '../../middlewares/rateLimiter.js';

const router = express.Router();

// Route pour le login utilisateur
router.post('/login', generalLimiter, validateLogin, loginUser);

// Route pour rafraîchir le token
router.post('/refresh-token', refreshTokenHandler);

// Route pour la déconnexion
router.post('/logout', logoutHandler);

export default router;
