import express, { json, urlencoded } from 'express';
import baseRoute from './routes/baseRoute.js';
import helmet from 'helmet';
import cors from 'cors';
import dotenv from 'dotenv';
import authRoutes from './routes/auth.js';
import { authenticateJWT } from './middlewares/authMiddleware.js';

// Initialisation de l'application Express
const app = express(); 

// Liste des origines autorisées
const allowedOrigins = [
    'http://localhost:9999',
    'http://127.0.0.1',
    'http://10.0.2.2',
  ]; 

  const corsOptions = {
    origin: allowedOrigins, // Autorise les requêtes provenant des origines spécifiées
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'], // Méthodes HTTP autorisées
    allowedHeaders: ['Content-Type', 'Authorization'], // En-têtes autorisés
    credentials: true, // Autorise l'envoi de cookies ou de headers comme Authorization
  };
  

// Charge les variables d'environnement depuis .env
dotenv.config(); 

// Middlewares globaux
app.use(json()); // Analyse les requêtes JSON
app.use(urlencoded({ extended: true })); // Analyse les requêtes URL-encoded

// Ajoute Helmet en tant que middleware
app.use(helmet({
    contentSecurityPolicy: false,
    frameguard: false,
})); 

// Applique les règles CORS
app.use(cors(corsOptions));

// Active CORS pour toutes les routes
app.options('*', cors(corsOptions));

// Utilisation des routes
app.use('/', baseRoute);
app.use('/auth', authRoutes);

//Routes Protégées
app.get('/protected', authenticateJWT, (req, res) => {
  res.send(`Welcome, user with role: ${req.user.role}`);
})

// Export de l'application Express
export default app;