import express from 'express';
import { registerUser } from '../../controllers/users/userRegistrationController.js';

const router = express.Router();

router.post('/', (req, res, next) => {
    console.log('Requête reçue sur /users/register');
    next();
  }, registerUser);
  
export default router;