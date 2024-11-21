import { BaseSchema } from '@adonisjs/lucid/schema'

export default class Messages extends BaseSchema {
  protected tableName = 'messages'

  public async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.uuid('id').primary().notNullable()
      table.uuid('groupId').references('id').inTable('groups').onDelete('CASCADE')
      table.uuid('userId').references('id').inTable('users').onDelete('CASCADE')
      table.text('content').notNullable()
      table.timestamp('createdAt').defaultTo(this.now())
    })
  }

  public async down() {
    this.schema.dropTable(this.tableName)
  }
}
