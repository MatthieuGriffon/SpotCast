import { BaseSchema } from '@adonisjs/lucid/schema'

export default class extends BaseSchema {
  protected tableName = 'groups'

  public async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.uuid('id').primary()
      table.string('name').notNullable()
      table.text('description').nullable()
      table.boolean('is_public').defaultTo(true)
      table.uuid('owner_id').notNullable().references('id').inTable('users')
      table.timestamp('created_at', { useTz: true }).defaultTo(this.now())
      table.timestamp('last_message_at', { useTz: true }).nullable()
    })
  }

  public async down() {
    this.schema.dropTable(this.tableName)
  }
}
