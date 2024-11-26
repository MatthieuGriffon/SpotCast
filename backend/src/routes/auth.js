import { Router } from 'express';
import { login, refreshToken, logout } from '../controllers/authController.js';

const router = Router();

// Définition des routes d'authentification
router.post('/login', login); // Endpoint pour la connexion
router.post('/refresh', refreshToken); // Endpoint pour régénérer le JWT
router.post('/logout', logout); // Endpoint pour la déconnexion

export default router;