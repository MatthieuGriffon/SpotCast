import 'dotenv/config'; // Charge automatiquement les variables d'environnement depuis .env
import app from './app.js'; // Importe l'application Express
import db from '../models/index.js'; // Importe l'instance Sequelize configurée

const PORT = process.env.PORT || 3000;

// Vérifie la connexion à la base de données et démarre le serveur
async function startServer() {
  try {
    // Teste la connexion à la base de données
    await db.sequelize.authenticate();
    console.log('Connection to the database has been established successfully.');

    // Démarre le serveur
    app.listen(PORT, () => {
      console.log(`Server is running on http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error('Unable to connect to the database:', error);
    process.exit(1); // Quitte le processus avec un code d'erreur
  }
}

startServer();
