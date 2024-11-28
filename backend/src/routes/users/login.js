import express from 'express';
import { loginUser } from '../../controllers/users/userLoginController.js';

const router = express.Router();

// Route pour le login utilisateur
router.post('/login', loginUser);

export default router;
