import rateLimit from 'express-rate-limit';

// Limite les requêtes : max. 10 tentatives toutes les 15 minutes
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 10, // Limite chaque IP à 10 requêtes par fenêtre
  message: {
    error: 'Too many login attempts. Please try again after 15 minutes.',
  },
  standardHeaders: true, // Retourne RateLimit-* headers
  legacyHeaders: false, // Désactive les X-RateLimit-* headers obsolètes
});

export default loginLimiter;