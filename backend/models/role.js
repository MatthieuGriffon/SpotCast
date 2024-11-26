'use strict';
import { Model, DataTypes } from 'sequelize';

export default (sequelize) => {
  class Role extends Model {
    /**
     * Définir les associations
     * Cette méthode est automatiquement appelée par le fichier models/index.js
     */
    static associate(models) {
      // Un rôle peut être associé à plusieurs utilisateurs
      Role.hasMany(models.User, { foreignKey: 'roleId', as: 'users' });
    }
  }

  Role.init(
    {
      name: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
      },
      description: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
    },
    {
      sequelize,
      modelName: 'Role',
    }
  );

  return Role;
};