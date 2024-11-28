import express from 'express';
import { getUserProfile } from '../../controllers/users/userProfileController.js';
import { authenticateJWT } from '../../middlewares/authMiddleware.js';

const router = express.Router();

// Route pour récupérer le profil utilisateur
router.get('/me', authenticateJWT, getUserProfile);

export default router;
