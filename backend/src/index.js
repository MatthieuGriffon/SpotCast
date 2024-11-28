import dotenv from 'dotenv'; // Charge les variables d'environnement
import app from './app.js'; // Importe l'application Express
import db from '../models/index.js'; // Importer l'objet `db` en tant qu'export par défaut
import express from 'express'; // Importe le framework Express
// Charger les variables d'environnement
dotenv.config();

// Définir le port du serveur
const PORT = process.env.PORT || 3000;
app.use(express.json()); 
// Fonction pour démarrer le serveur
async function startServer() {
  try {
    // Tester la connexion à la base de données
    await db.sequelize.authenticate();
    console.log('✅ Connection to the database has been established successfully.');

    // Lancer le serveur
    app.listen(PORT, () => {
      console.log(`🚀 Server is running on http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error('❌ Unable to connect to the database:', error);
    process.exit(1); // Quitte l'application avec un code d'erreur
  }
}

// Synchronisation des modèles et vérification
(async () => {
  try {
    // Synchronisation des modèles
    await db.sequelize.sync({ force: false });
    console.log('Database synchronized successfully.');

    // Vérification d'une requête simple
    const users = await db.User.findAll();
    console.log('Utilisateurs trouvés :', users);
  } catch (error) {
    console.error('Erreur lors du test :', error);
  }
})();

// Appel de la fonction pour démarrer le serveur
startServer();
