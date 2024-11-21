import { BaseSchema } from '@adonisjs/lucid/schema'

export default class extends BaseSchema {
  protected tableName = 'catches'

  public async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.uuid('id').primary()
      table.string('fish_type').notNullable()
      table.decimal('weight', 8, 2).notNullable()
      table.decimal('length', 8, 2).notNullable()
      table.string('bait_used').nullable()
      table.uuid('spot_id').notNullable().references('id').inTable('spots')
      table.string('photo').nullable()
      table.uuid('user_id').notNullable().references('id').inTable('users')
      table.timestamp('created_at', { useTz: true }).defaultTo(this.now())
    })
  }

  public async down() {
    this.schema.dropTable(this.tableName)
  }
}
