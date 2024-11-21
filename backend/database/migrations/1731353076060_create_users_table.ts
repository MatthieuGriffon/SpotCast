import { BaseSchema } from '@adonisjs/lucid/schema'

export default class extends BaseSchema {
  protected tableName = 'users'

  public async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.uuid('id').primary()
      table.string('email').notNullable().unique()
      table.string('password').nullable()
      table.string('name').notNullable()
      table.text('bio').nullable()
      table.string('photo').nullable()
      table.enum('provider', ['local', 'google', 'facebook']).defaultTo('local')
      table.string('provider_id').nullable()
      table.string('refresh_token').nullable()
      table.timestamp('created_at', { useTz: true }).defaultTo(this.now())
      table.timestamp('updated_at', { useTz: true }).defaultTo(this.now())
      table.timestamp('last_login_at', { useTz: true }).nullable()
      table.boolean('is_active').defaultTo(true)
    })
  }

  public async down() {
    this.schema.dropTable(this.tableName)
  }
}
