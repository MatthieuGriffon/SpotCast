import dotenv from 'dotenv'; // Charge les variables d'environnement
import app from './app.js'; // Importe l'application Express
import { db } from '../models/index.js'; // Importe le registre des modèles Sequelize avec destructuration

// Charger les variables d'environnement
dotenv.config();

// Définir le port du serveur
const PORT = process.env.PORT || 3000;

// Fonction pour démarrer le serveur
async function startServer() {
  try {
    // Tester la connexion à la base de données
    await db.sequelize.authenticate();
    console.log('✅ Connection to the database has been established successfully.');

    await db.sequelize.sync({ alter: true });
    // Synchroniser les modèles avec la base de données (optionnel : { alter: true } pour ajuster les tables)
    await db.sequelize.sync();
    console.log('✅ Database synchronized successfully.');

    // Lancer le serveur
    app.listen(PORT, () => {
      console.log(`🚀 Server is running on http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error('❌ Unable to connect to the database:', error);
    process.exit(1); // Quitte l'application avec un code d'erreur
  }
}

// Appel de la fonction pour démarrer le serveur
startServer();
