import express, { json, urlencoded } from 'express';
import session from 'express-session';
import helmet from 'helmet';
import cors from 'cors';
import dotenv from 'dotenv';
import { authenticateJWT, authorizeRole } from './middlewares/authMiddleware.js';
import  {generalLimiter } from './middlewares/rateLimiter.js'; // Import du middleware

// Importe les routes
import baseRoute from './routes/baseRoute.js';
import authRoutes from './routes/auth.js';
import protectedRoutes from './routes/protected.js';
import userRegisterRoutes from './routes/users/register.js';
import userLoginRoutes from './routes/users/login.js';
import passwordResetRoutes from './routes/users/passwordReset.js';
import userProfileRoutes from './routes/users/profile.js';

// Import de la configuration Passport
import passport from '../config/passport.js';

// Initialisation de l'application Express
const app = express();
app.set('trust proxy', 1);

// Configuration de la session
app.use(
  session({
    secret: process.env.SESSION_SECRET || 'votre_secret_de_session',
    resave: false, // Ne sauvegarde pas la session si elle n'est pas modifiée
    saveUninitialized: false, // Ne crée pas une session si aucune donnée n'est sauvegardée
    cookie: {
      secure: process.env.NODE_ENV === 'production', // Utilise des cookies sécurisés en production
      maxAge: 3600000, // Durée de validité : 1 heure
    },
  })
);

app.use(passport.initialize());
app.use(passport.session());

// Liste des origines autorisées
const allowedOrigins = [
    'http://localhost:9999',
    'http://127.0.0.1',
    'http://10.0.2.2',
    'https://spotcast-dev.loca.lt',
  ]; 

  const corsOptions = {
    origin: allowedOrigins, // Autorise les requêtes provenant des origines spécifiées
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'], // Méthodes HTTP autorisées
    allowedHeaders: ['Content-Type', 'Authorization'], // En-têtes autorisés
    credentials: true, // Autorise l'envoi de cookies ou de headers comme Authorization
  };

// Charge les variables d'environnement depuis .env
dotenv.config();
console.log('JWT_SECRET:', process.env.JWT_SECRET);
console.log('REFRESH_TOKEN_SECRET:', process.env.REFRESH_TOKEN_SECRET);
// Applique le middleware de limitation
//app.use(generalLimiter);

// Middlewares globaux
app.use(json()); // Analyse les requêtes JSON
app.use(urlencoded({ extended: true })); // Analyse les requêtes URL-encoded

// Initialiser Passport.js
app.use(passport.initialize());
console.log('Passport initialisé');
app.use(passport.session());

app.use((err, req, res, next) => {
  console.error('Erreur Passport :', err);
  res.status(500).json({
    message: 'Erreur Passport',
    error: process.env.NODE_ENV === 'development' ? err : 'An error occurred',
  });
});
// Ajoute Helmet en tant que middleware
//app.use(helmet({
//    contentSecurityPolicy: false,
//    frameguard: false,
//})); 

// Applique les règles CORS
app.use(cors(corsOptions));

// Active CORS pour toutes les routes
app.options('*', cors(corsOptions));

// 
app.use((req, res, next) => {
  console.log(`Requête reçue : ${req.method} ${req.url}`);
  next();
});
// Utilisation des routes
app.use('/', baseRoute);
app.use('/auth', authRoutes);
app.use('/protected', protectedRoutes);
app.use('/users', userLoginRoutes);

// Point d'entrée pour toutes les routes des utilisateurs
app.use('/users/register', userRegisterRoutes);
app.use('/users/password-reset', passwordResetRoutes);
app.use('/users', userProfileRoutes);



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
app._router.stack.forEach((middleware) => {
  if (middleware.route) { // Vérifie si le middleware est une route
    console.log(`Route définie : ${middleware.route.path}`);
  } else if (middleware.name === 'router') { // Vérifie si le middleware est un routeur
    middleware.handle.stack.forEach((handler) => {
      if (handler.route) {
        console.log(`Route définie : ${handler.route.path}`);
      }
    });
  }
});

// Export de l'application Express
export default app;