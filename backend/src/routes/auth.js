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
// Gestion des échecs d'authentification
router.get('/google/failure', (req, res) => {
  res.status(401).json({ message: 'Google Authentication Failed' });
});

export default router;