import { BaseSchema } from '@adonisjs/lucid/schema'

export default class extends BaseSchema {
  protected tableName = 'events'

  public async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.uuid('id').primary()
      table.string('title').notNullable()
      table.text('description').nullable()
      table.timestamp('date', { useTz: true }).notNullable()
      table.string('location').nullable()
      table.uuid('created_by').notNullable().references('id').inTable('users')
      table.uuid('group_id').nullable().references('id').inTable('groups')
    })
  }

  public async down() {
    this.schema.dropTable(this.tableName)
  }
}
