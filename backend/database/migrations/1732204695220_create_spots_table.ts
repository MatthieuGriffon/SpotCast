import { BaseSchema } from '@adonisjs/lucid/schema'

export default class Spots extends BaseSchema {
  protected tableName = 'spots'

  public async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.uuid('id').primary().notNullable()
      table.string('name').notNullable()
      table.text('description').nullable()
      table.decimal('latitude', 10, 7).notNullable()
      table.decimal('longitude', 10, 7).notNullable()
      table.uuid('userId').references('id').inTable('users').onDelete('CASCADE')
      table.enum('visibility', ['public', 'group', 'private']).defaultTo('public')
      table.timestamp('createdAt').defaultTo(this.now())
    })
  }

  public async down() {
    this.schema.dropTable(this.tableName)
  }
}
