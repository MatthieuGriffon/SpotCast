import { rateLimit } from 'express-rate-limit';

// Limitation générale
const generalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 50, // Limiter à 100 requêtes par IP toutes les 15 minutes
  message: { message: 'Too many requests, please try again later.' },
  standardHeaders: true,
  legacyHeaders: false,
});

// Limitation stricte pour les tentatives sensibles comme la réinitialisation de mot de passe
const passwordResetLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // Seulement 5 tentatives de réinitialisation par IP
  message: { message: 'Too many password reset attempts from this IP, please try again after 15 minutes.' },
  standardHeaders: true,
  legacyHeaders: false,
});

export { generalLimiter, passwordResetLimiter };