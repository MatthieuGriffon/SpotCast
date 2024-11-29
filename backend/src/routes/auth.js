import express from 'express';
import passport from 'passport';
import jwt from 'jsonwebtoken';

const router = express.Router();

// Route pour démarrer l'authentification Google
router.get('/google', passport.authenticate('google',
   { scope: ['profile', 'email'],
    prompt: 'consent',
    }));

// Route pour gérer le callback après l'authentification Google
router.get('/google/callback',
  passport.authenticate('google', { failureRedirect: '/login', session: false }),
  (req, res) => {
    console.log('Callback Google reçu');
    
    // Génération du token JWT
    const token = jwt.sign(
      { id: req.user.id, email: req.user.email },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    // Redirection vers l'application Flutter avec le token
    const redirectUrl = `com.example.spotcast://oauth2redirect?token=${token}`;
    console.log('Redirection vers :', redirectUrl);
    res.redirect(redirectUrl);
  }
);

export default router;
