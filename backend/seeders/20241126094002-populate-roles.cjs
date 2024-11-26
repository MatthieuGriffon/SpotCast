'use strict';

module.exports = {
  async up(queryInterface) {
    // Récupère les rôles existants dans la base de données
    const existingRoles = await queryInterface.sequelize.query(
      `SELECT "name" FROM "Roles"`,
      { type: queryInterface.sequelize.QueryTypes.SELECT }
    );

    // Crée une liste des noms de rôles existants
    const existingRoleNames = existingRoles.map(role => role.name);

    // Définis les rôles à insérer
    const rolesToInsert = [
      { name: 'admin', description: 'Administrateur global' },
      { name: 'user', description: 'Utilisateur standard' },
      { name: 'groupOwner', description: 'Propriétaire d’un groupe' },
      { name: 'groupMember', description: 'Membre d’un groupe' },
      { name: 'eventParticipant', description: 'Participant à un événement' },
    ];

    // Filtre les rôles pour ne garder que ceux qui n'existent pas déjà
    const newRoles = rolesToInsert.filter(role => !existingRoleNames.includes(role.name));

    // Insère uniquement les rôles qui n'existent pas
    if (newRoles.length > 0) {
      await queryInterface.bulkInsert(
        'Roles',
        newRoles.map(role => ({
          id: queryInterface.sequelize.literal('gen_random_uuid()'), // UUID généré côté PostgreSQL
          name: role.name,
          description: role.description,
          createdAt: new Date(),
          updatedAt: new Date(),
        }))
      );
    }
  },

  async down(queryInterface) {
    // Supprime tous les rôles ajoutés par cette Seed
    await queryInterface.bulkDelete('Roles', {
      name: ['admin', 'user', 'groupOwner', 'groupMember', 'eventParticipant'],
    });
  },
};
