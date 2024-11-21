import { BaseSchema } from '@adonisjs/lucid/schema'

export default class Users extends BaseSchema {
  protected tableName = 'users'

  public async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.uuid('id').primary().notNullable()
      table.string('email', 254).notNullable().unique()
      table.string('password').nullable()
      table.string('name').notNullable()
      table.text('bio').nullable()
      table.string('photo').nullable()
      table.enum('provider', ['local', 'google', 'facebook']).defaultTo('local')
      table.string('providerId').nullable()
      table.string('refreshToken').nullable()
      table.timestamp('createdAt').defaultTo(this.now())
      table.timestamp('updatedAt').defaultTo(this.now())
      table.timestamp('lastLoginAt').nullable()
      table.boolean('isActive').defaultTo(true)
    })
  }

  public async down() {
    this.schema.dropTable(this.tableName)
  }
}
