import passport from 'passport';
import { Strategy as GoogleStrategy } from 'passport-google-oauth20'; // Import correct de GoogleStrategy
import { User, Role, FederatedCredential } from '../models/index.js';// Import des modèles Sequelize
import db from '../models/index.js';// Importe le registre des modèles Sequelize avec destructuration
console.log('Chargement de passport.js');

// Vérification que les modèles sont correctement chargés
console.log('Modèles Sequelize vérifiés :');
console.log('User model chargé :', !!User);
console.log('Role model chargé :', !!Role);
console.log('FederatedCredential model chargé :', !!FederatedCredential);

// Configuration de la stratégie Google
passport.use(
  new GoogleStrategy(
    {
      clientID: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
      callbackURL: process.env.CALLBACK_URL,
      scope: ['profile', 'email'],
    },
    async (accessToken, refreshToken, profile, done) => {
      try {
        console.log('Profil Google reçu :', profile);

        const email = profile.emails[0]?.value || null;

        // Vérifiez si l'utilisateur existe déjà
        let user = await db.User.findOne({ where: { email } });

        if (!user) {
          console.log('Aucun utilisateur trouvé avec cet email. Création d’un nouvel utilisateur.');

          const defaultRole = await db.Role.findOne({ where: { name: 'user' } });
          if (!defaultRole) {
            throw new Error("Le rôle par défaut 'user' n'existe pas.");
          }

          user = await db.User.create({
            name: profile.displayName,
            email,
            photo: profile.photos[0]?.value || null,
            roleId: defaultRole.id,
            provider: 'google',
          });

          await db.FederatedCredential.create({
            userId: user.id,
            provider: 'google',
            subject: profile.id,
          });
        }

        return done(null, user);
      } catch (err) {
        console.error('Erreur pendant la vérification de Google :', err);
        return done(err);
      }
    }
  )
);
// Sérialisation des données utilisateur pour la session
passport.serializeUser((user, done) => {
  done(null, user);
});

passport.deserializeUser((user, done) => {
  done(null, user);
});

export default passport;
