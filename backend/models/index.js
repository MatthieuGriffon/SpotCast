'use strict';

import Sequelize from 'sequelize';
import User from './user.js';
import Role from './role.js';
import FederatedCredential from './FederatedCredential.js';
import pkg from '../config/config.cjs'; // Import des configurations

// Chargement de la configuration en fonction de l'environnement
const { development, test, production } = pkg;
const env = process.env.NODE_ENV || 'development';
const config = env === 'production' ? production : env === 'test' ? test : development;

// Initialisation de Sequelize
const sequelize = config.use_env_variable
  ? new Sequelize(process.env[config.use_env_variable], config)
  : new Sequelize(config.database, config.username, config.password, config);

// Initialisation des modèles
const db = {
  User: User(sequelize, Sequelize.DataTypes),
  Role: Role(sequelize, Sequelize.DataTypes),
  FederatedCredential: FederatedCredential(sequelize, Sequelize.DataTypes),
};

// Application des associations entre modèles
Object.keys(db).forEach((modelName) => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

// Ajout des instances Sequelize à l'objet db
db.sequelize = sequelize;
db.Sequelize = Sequelize;

// Export explicite des modèles pour éviter tout conflit
export { User, Role, FederatedCredential };
export default db;
