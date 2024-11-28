import express, { json, urlencoded } from 'express';
import helmet from 'helmet';
import cors from 'cors';
import dotenv from 'dotenv';
import { authenticateJWT, authorizeRole } from './middlewares/authMiddleware.js';
// Importe les routes
import baseRoute from './routes/baseRoute.js';
import authRoutes from './routes/auth.js';
import protectedRoutes from './routes/protected.js';
import passport from '../config/passport.js';// Import de la configuration Passportconsole.log('Chargement de Passport terminé');
import userRegisterRoutes from './routes/users/register.js';


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

// Initialiser Passport.js
app.use(passport.initialize());
console.log('Passport initialisé');

app.use((err, req, res, next) => {
  console.error('Erreur Passport :', err);
  res.status(500).json({
    message: 'Erreur Passport',
    error: process.env.NODE_ENV === 'development' ? err : 'An error occurred',
  });
});
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
app.use('/protected', protectedRoutes);

// Point d'entrée pour toutes les routes des utilisateurs
app.use('/users/register', userRegisterRoutes);



//Routes Protégées
app.get('/protected', authenticateJWT, (req, res) => {
  res.send(`Welcome, user with role: ${req.user.role}`);
})
app.get('/protected', authenticateJWT, (req, res) => {
  res.send(`Welcome, user with role: ${req.user.role}`);
});

app.get('/admin', authenticateJWT, authorizeRole('admin'), (req, res) => {
  res.send('Welcome, admin!');
});

app.get('/moderator', authenticateJWT, authorizeRole('moderator'), (req, res) => {
  res.send('Welcome, moderator!');
});

// Export de l'application Express
export default app;