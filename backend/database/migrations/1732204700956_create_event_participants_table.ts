import { BaseSchema } from '@adonisjs/lucid/schema'

export default class EventParticipants extends BaseSchema {
  protected tableName = 'event_participants'

  public async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.uuid('eventId').references('id').inTable('events').onDelete('CASCADE')
      table.uuid('userId').references('id').inTable('users').onDelete('CASCADE')
      table.enum('status', ['invited', 'confirmed', 'cancelled']).defaultTo('invited')
      table.primary(['eventId', 'userId']) // Clé composite
    })
  }

  public async down() {
    this.schema.dropTable(this.tableName)
  }
}
