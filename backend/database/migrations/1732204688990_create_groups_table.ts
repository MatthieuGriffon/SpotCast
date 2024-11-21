import { BaseSchema } from '@adonisjs/lucid/schema'

export default class Groups extends BaseSchema {
  protected tableName = 'groups'

  public async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.uuid('id').primary().notNullable()
      table.string('name').notNullable()
      table.text('description').nullable()
      table.boolean('isPublic').defaultTo(true)
      table.uuid('ownerId').references('id').inTable('users').onDelete('CASCADE')
      table.timestamp('createdAt').defaultTo(this.now())
      table.timestamp('lastMessageAt').nullable()
    })
  }

  public async down() {
    this.schema.dropTable(this.tableName)
  }
}
