import { BaseSchema } from '@adonisjs/lucid/schema'

export default class Events extends BaseSchema {
  protected tableName = 'events'

  public async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.uuid('id').primary().notNullable()
      table.string('title').notNullable()
      table.text('description').nullable()
      table.timestamp('date').notNullable()
      table.string('location').nullable()
      table.uuid('createdBy').references('id').inTable('users').onDelete('CASCADE')
      table.uuid('groupId').references('id').inTable('groups').onDelete('CASCADE')
    })
  }

  public async down() {
    this.schema.dropTable(this.tableName)
  }
}
