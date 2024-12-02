import { body, validationResult } from 'express-validator';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import db from '../../../models/index.js';
import { generateAccessToken, generateRefreshToken,verifyRefreshToken } from '../../utils/tokenUtils.js';

const { User, Role } = db;

export const validateLogin = [
  body('email').isEmail().withMessage('Invalid email format'),
  body('password').notEmpty().withMessage('Password is required'),
];

export const loginUser = async (req, res) => {
  try {
    console.log('Requête reçue pour login avec les données :', req.body);
    // Validation des données d'entrée
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      console.log('Erreurs de validation :', errors.array());
      return res.status(400).json({ errors: errors.array() });
    }

    const { email, password } = req.body;

    // Rechercher l'utilisateur
    const user = await User.findOne({
      where: { email },
      include: [{ model: Role, as: 'role' }],
    });

    if (!user) {
      console.log(`Utilisateur non trouvé pour l'email : ${email}`);
      return res.status(404).json({ message: 'User not found' });
    }

    // Vérification du mot de passe
    const isMatch = await bcrypt.compare(password, user.password);
    console.log('Vérification du mot de passe réussie ? :', isMatch);
    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

     // Génération des tokens
     const accessToken = generateAccessToken(user);
     const refreshToken = generateRefreshToken(user);
     console.log('Tokens générés :', { accessToken, refreshToken });
 
     // Mise à jour du Refresh Token dans la table Users
     await user.update({ refreshToken });
     console.log('Refresh token mis à jour dans la base de données pour l\'utilisateur :', user.id);

 
     // Réponse au client
     res.status(200).json({
       message: 'Login successful',
       accessToken,
       refreshToken,
       user: {
         id: user.id,
         email: user.email,
         name: user.name,
         role: user.role.name,
       },
     });
   } catch (error) {
     console.error('Error during login:', error);
     res.status(500).json({ message: 'Server error' });
   }
 };

 export const refreshTokenHandler = async (req, res) => {
  console.log('Requête reçue pour rafraîchir le token avec le body :', req.body);

  const { refreshToken } = req.body;

  if (!refreshToken) {
    console.log('Aucun refresh token fourni');
    return res.status(400).json({ message: 'Refresh Token is required' });
  }

  try {
    const payload = verifyRefreshToken(refreshToken);
    console.log('Payload du Refresh Token décodé :', payload);

    // Vérifie si le Refresh Token correspond à celui stocké dans la base
    const user = await User.findOne({ where: { id: payload.id, refreshToken } });
    console.log('Utilisateur trouvé pour le Refresh Token ?', !!user);

    if (!user) {
      return res.status(403).json({ message: 'Invalid Refresh Token' });
    }

    // Générer un nouveau Access Token
    const newAccessToken = generateAccessToken(user);
    console.log('Nouveau Access Token généré :', newAccessToken);

    res.status(200).json({ accessToken: newAccessToken });
  } catch (error) {
    console.error('Error refreshing token:', error);
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ message: 'Refresh Token has expired' });
    }
    res.status(403).json({ message: 'Invalid Refresh Token' });
  }
};

export const logoutHandler = async (req, res) => {
  console.log('Requête reçue pour logout avec le body :', req.body);

  const { refreshToken } = req.body;

  if (!refreshToken) {
    console.log('Aucun refresh token fourni');
    return res.status(400).json({ message: 'Refresh Token is required' });
  }

  try {
    // Rechercher l'utilisateur associé au Refresh Token
    const user = await User.findOne({ where: { refreshToken } });
    console.log('Utilisateur trouvé pour le Refresh Token ?', !!user);

    if (!user) {
      return res.status(403).json({ message: 'Invalid Refresh Token' });
    }

    // Révoquer le Refresh Token
    await user.update({ refreshToken: null });
    console.log('Refresh Token révoqué pour l\'utilisateur :', user.id);

    res.status(200).json({ message: 'Logout successful' });
  } catch (error) {
    console.error('Error during logout:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

