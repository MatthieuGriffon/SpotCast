import { BaseSchema } from '@adonisjs/lucid/schema'

export default class extends BaseSchema {
  protected tableName = 'event_participants'

  public async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.uuid('event_id').references('id').inTable('events').onDelete('CASCADE')
      table.uuid('user_id').references('id').inTable('users').onDelete('CASCADE')
      table.enum('status', ['invited', 'confirmed', 'cancelled']).defaultTo('invited')
      table.primary(['event_id', 'user_id'])
    })
  }

  public async down() {
    this.schema.dropTable(this.tableName)
  }
}
