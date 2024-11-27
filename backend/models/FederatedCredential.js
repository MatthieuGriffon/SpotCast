'use strict';
import { Model, DataTypes } from 'sequelize';

export default (sequelize) => {
  class FederatedCredential extends Model {
    static associate(models) {
      // Relation entre FederatedCredential et User
      FederatedCredential.belongsTo(models.User, { foreignKey: 'userId', as: 'user' });
    }
  }

  FederatedCredential.init(
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4, // Génère automatiquement un UUID
        allowNull: false,
        primaryKey: true,
      },
      provider: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      subject: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      userId: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
    },
    {
      sequelize,
      modelName: 'FederatedCredential',
      tableName: 'FederatedCredentials',
    }
  );

  return FederatedCredential;
};
