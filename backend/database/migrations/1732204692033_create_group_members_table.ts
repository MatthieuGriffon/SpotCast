import { BaseSchema } from '@adonisjs/lucid/schema'

export default class GroupMembers extends BaseSchema {
  protected tableName = 'group_members'

  public async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.uuid('groupId').references('id').inTable('groups').onDelete('CASCADE')
      table.uuid('userId').references('id').inTable('users').onDelete('CASCADE')
      table.enum('role', ['admin', 'member']).defaultTo('member')
      table.primary(['groupId', 'userId']) // Clé composite
    })
  }

  public async down() {
    this.schema.dropTable(this.tableName)
  }
}
