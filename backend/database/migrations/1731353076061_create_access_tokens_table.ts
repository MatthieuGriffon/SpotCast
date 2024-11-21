import { BaseSchema } from '@adonisjs/lucid/schema'

export default class extends BaseSchema {
  protected tableName = 'auth_access_tokens'

  async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.increments('id') // Utilise un entier pour l'identifiant interne de cette table
      table
        .uuid('uuid') // Corrige le type en uuid pour correspondre à la clé primaire de users
        .notNullable()
        .references('id') // La clé étrangère fait référence à 'id' de la table 'users'
        .inTable('users')
        .onDelete('CASCADE') // Supprime les tokens si l'utilisateur est supprimé

      table.string('type').notNullable()
      table.string('name').nullable()
      table.string('hash').notNullable()
      table.text('abilities').notNullable()
      table.timestamp('created_at', { useTz: true }).defaultTo(this.now())
      table.timestamp('updated_at', { useTz: true }).defaultTo(this.now())
      table.timestamp('last_used_at', { useTz: true }).nullable()
      table.timestamp('expires_at', { useTz: true }).nullable()
    })
  }

  async down() {
    this.schema.dropTable(this.tableName)
  }
}
