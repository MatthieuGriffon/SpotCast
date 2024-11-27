'use strict';

import Sequelize from 'sequelize';
import User from './user.js';
import Role from './role.js';
import FederatedCredential from './FederatedCredential.js';
console.log('Méthodes disponibles sur FederatedCredential :', Object.keys(FederatedCredential));
console.log ('Modèle FederatedCredential chargé :', FederatedCredential);
 // Import direct des modèles
import pkg from '../config/config.cjs';

const { development, test, production } = pkg;

const env = process.env.NODE_ENV || 'development';
const config = env === 'production' ? production : env === 'test' ? test : development;

const db = {};

// Initialiser Sequelize
let sequelize;
if (config.use_env_variable) {
  sequelize = new Sequelize(process.env[config.use_env_variable], config);
} else {
  sequelize = new Sequelize(config.database, config.username, config.password, config);
}

// Initialiser les modèles
db.User = User(sequelize, Sequelize.DataTypes);
db.Role = Role(sequelize, Sequelize.DataTypes);
db.FederatedCredential = FederatedCredential(sequelize, Sequelize.DataTypes);

console.log('Modèle User chargé :', db.User);
console.log('Modèle Role chargé :', db.Role);
console.log('On charge le modèle FederatedCredential', FederatedCredential);
console.log('Modèle FederatedCredential chargé :', db.FederatedCredential);
console.log('Méthodes disponibles sur FederatedCredential :', Object.keys(db.FederatedCredential));

Object.keys(db).forEach((modelName) => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

// Exporter les modèles
db.sequelize = sequelize;
db.Sequelize = Sequelize;
console.log('Méthodes disponibles sur User :', Object.keys(db.User));
console.log('Méthodes disponibles sur Role :', Object.keys(db.Role));
console.log('Méthodes disponibles sur FederatedCredential :', Object.keys(db.FederatedCredential));
// Exporter explicitement les modèles si nécessaire
export default db;
export { User, Role, FederatedCredential, db }; // Pour permettre un import par défaut
