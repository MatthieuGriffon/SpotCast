import express from 'express';
import { registerUser } from '../../controllers/users/userRegistrationController.js';

const router = express.Router();

// Vérifier que la méthode POST est bien définie
router.post('/', registerUser); // Notez l'usage de '/' ici
export default router;