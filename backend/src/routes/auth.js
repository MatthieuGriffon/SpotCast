import express from 'express';
import passport from 'passport';
import jwt from 'jsonwebtoken';
import { generateAccessToken, generateRefreshToken } from '../utils/tokenUtils.js'; // Import des utils
import { User, Role } from '../../models/index.js'; // Import du modèle User

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
    
    // Récupérer les tokens de l'utilisateur
    const { accessToken, refreshToken } = req.user;

    // Redirection vers l'application Flutter avec les tokens
    const redirectUrl = `com.example.spotcast://oauth2redirect?accessToken=${accessToken}&refreshToken=${refreshToken}`;
    console.log('Redirection vers :', redirectUrl);

    res.redirect(redirectUrl);
  }
);


export default router;
