'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    // Étape 1 : Ajouter la colonne sans valeur par défaut
    await queryInterface.addColumn('Users', 'roleId', {
      type: Sequelize.UUID,
      references: {
        model: 'Roles',
        key: 'id',
      },
      allowNull: true, // Permet temporairement les valeurs nulles
    });

    // Étape 2 : Mettre à jour tous les utilisateurs avec le rôle par défaut (user)
    const [results] = await queryInterface.sequelize.query(
      `SELECT id FROM "Roles" WHERE name = 'user' LIMIT 1;`
    );

    const defaultRoleId = results[0]?.id;
    if (defaultRoleId) {
      await queryInterface.sequelize.query(
        `UPDATE "Users" SET "roleId" = '${defaultRoleId}' WHERE "roleId" IS NULL;`
      );
    } else {
      throw new Error('Rôle "user" introuvable. Veuillez vérifier les rôles dans la table "Roles".');
    }

    // Étape 3 : Ajouter la contrainte NOT NULL
    await queryInterface.changeColumn('Users', 'roleId', {
      type: Sequelize.UUID,
      references: {
        model: 'Roles',
        key: 'id',
      },
      allowNull: false,
    });
  },

  async down(queryInterface) {
    // Supprimer la colonne
    await queryInterface.removeColumn('Users', 'roleId');
  },
};
