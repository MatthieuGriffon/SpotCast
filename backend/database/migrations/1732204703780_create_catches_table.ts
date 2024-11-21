import { BaseSchema } from '@adonisjs/lucid/schema'

export default class Catches extends BaseSchema {
  protected tableName = 'catches'

  public async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.uuid('id').primary().notNullable()
      table.string('fishType').notNullable()
      table.decimal('weight', 10, 2).nullable()
      table.decimal('length', 10, 2).nullable()
      table.string('baitUsed').nullable()
      table.uuid('spotId').references('id').inTable('spots').onDelete('CASCADE')
      table.string('photo').nullable()
      table.uuid('userId').references('id').inTable('users').onDelete('CASCADE')
      table.timestamp('createdAt').defaultTo(this.now())
    })
  }

  public async down() {
    this.schema.dropTable(this.tableName)
  }
}
