'use strict';

import Sequelize from 'sequelize';
import User from './user.js';
import Role from './role.js';
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

// Initialiser le modèle User
db.User = User(sequelize, Sequelize.DataTypes);
db.Role = Role(sequelize, Sequelize.DataTypes);

// Configurer les associations
Object.keys(db).forEach((modelName) => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

// Exporter l'instance Sequelize et les modèles
db.sequelize = sequelize;
db.Sequelize = Sequelize;

export default db;
