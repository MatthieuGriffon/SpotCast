import express from 'express';
import { authenticateJWT } from '../middlewares/authMiddleware.js';

const router = express.Router();

// Exemple de route protégée
router.get('/dashboard', authenticateJWT, (req, res) => {
  res.status(200).json({
    message: `Welcome to the dashboard, ${req.user.role} user.`,
    user: req.user, // Informations issues du JWT
  });
});

export default router;
