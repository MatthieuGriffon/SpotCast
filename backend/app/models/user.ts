import { DateTime } from 'luxon'
import hash from '@adonisjs/core/services/hash'
import { compose } from '@adonisjs/core/helpers'
import { BaseModel, column, beforeCreate } from '@adonisjs/lucid/orm'
import { withAuthFinder } from '@adonisjs/auth/mixins/lucid'
import { DbAccessTokensProvider, AccessToken } from '@adonisjs/auth/access_tokens'
import { v4 as uuidv4 } from 'uuid'

// Configuration pour le hashage des mots de passe
const AuthFinder = withAuthFinder(() => hash.use('scrypt'), {
  uids: ['email'], // Identifier l'utilisateur par son email
  passwordColumnName: 'password', // Nom de la colonne contenant les mots de passe
})

export default class User extends compose(BaseModel, AuthFinder) {
  /** ID principal de l'utilisateur (UUID) */
  @column({ isPrimary: true })
  declare id: string

  /** Email de l'utilisateur */
  @column()
  declare email: string

  /** Mot de passe haché (ne sera pas sérialisé dans les réponses) */
  @column({ serializeAs: null })
  declare password: string | null

  /** Nom complet de l'utilisateur */
  @column()
  declare name: string

  /** Biographie de l'utilisateur */
  @column()
  declare bio: string | null

  /** URL de la photo de profil */
  @column()
  declare photo: string | null

  /** Méthode d'authentification utilisée : local, google ou facebook */
  @column()
  declare provider: 'local' | 'google' | 'facebook'

  /** Identifiant spécifique au fournisseur OAuth */
  @column()
  declare providerId: string | null

  /** Jeton de rafraîchissement pour OAuth */
  @column()
  declare refreshToken: string | null

  @column.dateTime({ autoCreate: true, columnName: 'createdAt' })
  public createdAt!: DateTime

  @column.dateTime({ autoCreate: true, autoUpdate: true, columnName: 'updatedAt' })
  public updatedAt!: DateTime

  /** Date de la dernière connexion */
  @column.dateTime()
  declare lastLoginAt: DateTime | null

  /** Statut actif ou inactif de l'utilisateur */
  @column()
  declare isActive: boolean

  @beforeCreate()
  public static assignUuid(user: User) {
    user.id = uuidv4()
  }

  /** Configuration des tokens d'accès pour l'utilisateur */
  static accessTokens = DbAccessTokensProvider.forModel(User, {
    expiresIn: '30 days', // Durée de validité des tokens
    prefix: 'oat_', // Préfixe des tokens
    table: 'auth_access_tokens', // Table des tokens
    type: 'auth_token', // Type de token
    tokenSecretLength: 40,
  })

  /** Jeton d'accès courant pour les requêtes authentifiées */
  public currentAccessToken?: AccessToken
}
