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
router.get(
  '/google',
  passport.authenticate('google', { scope: ['profile', 'email'] }),
  (req, res) => {
    console.log('Requête reçue sur /auth/google');
    res.send('Authentification en cours...');
  }
);

// Route pour gérer le callback Google
router.get(
  '/google/callback',
  passport.authenticate('google', { failureRedirect: '/login', session: false }),
  (req, res) => {
    const user = req.user;
    const token = jwt.sign(
      { id: user.id, email: user.email, role: user.roleId },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );
    console.log('Requête reçue sur /auth/google/callback');
    res.json({
      message: 'Login successful',
      user: req.user,
      token,
    });
    console.log ('Fin de la requête sur /auth/google/callback', req.user, token);
  }
);
// Route pour gérer l'échec de l'authentification Google
router.post('/refresh', async (req, res) => {
  const { refreshToken } = req.body;
  if (!refreshToken) return res.status(400).json({ message: 'Refresh Token Required' });

  try {
    const user = await db.User.findOne({ where: { refreshToken } });
    if (!user) return res.status(403).json({ message: 'Invalid Refresh Token' });

    const newToken = jwt.sign(
      { id: user.id, email: user.email, role: user.roleId },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );
    res.json({ token: newToken });
  } catch (err) {
    res.status(500).json({ message: 'Server Error' });
  }
});
// Route pour gérer la déconnexion
router.get('/google/failure', (req, res) => {
  res.status(401).json({ message: 'Google Authentication Failed' });
});

export default router;