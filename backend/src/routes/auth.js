import express from 'express';
import passport from 'passport';
import jwt from 'jsonwebtoken';

// Import de la configuration Passport.js
import { login, refreshToken, logout } from '../controllers/authController.js';

const router = express.Router();


// Endpoints d'authentification classique
router.post('/login', login); // Endpoint pour la connexion classique
router.post('/refresh', refreshToken); // Endpoint pour régénérer le JWT
router.post('/logout', logout); // Endpoint pour la déconnexion

// Route pour démarrer l'authentification Google
console.log('Route /auth/google configurée');
router.get(
  '/google',
  passport.authenticate('google', { scope: ['profile', 'email'] }),
  (req, res) => {
    console.log('Requête reçue sur /auth/google');
    res.send('Authentification en cours...');
  }
);
console.log('Route /auth/google/callback configurée');
// Callback après authentification réussie ou échec
// Route pour gérer le callback Google
router.get(
  '/google/callback',
  passport.authenticate('google', { failureRedirect: '/login', session: false }),
  (req, res) => {
    console.log('Requête reçue sur /auth/google/callback');
    res.json({
      message: 'Login successful',
      user: req.user,
    });
  }
);
// Gestion des échecs d'authentification
router.get('/google/failure', (req, res) => {
  res.status(401).json({ message: 'Google Authentication Failed' });
});

export default router;