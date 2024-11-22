import { HttpContext } from '@adonisjs/core/http'
import User from '../models/user.js'
import hash from '@adonisjs/core/services/hash'

export default class UsersController {
  public async store({ request, response }: HttpContext) {
    const { email, password, name, bio } = request.only(['email', 'password', 'name', 'bio'])

    try {
      if (!email || !password || !name) {
        return response.badRequest({ message: 'Missing required fields' })
      }

      const existingUser = await User.query().where('email', email).first()
      if (existingUser) {
        return response.conflict({ message: 'Email already in use' })
      }

      const hashedPassword = await hash.make(password)
      const user = await User.create({
        email,
        password: hashedPassword,
        name,
        bio,
        provider: 'local',
      })

      // Génération de l'access token
      const token = await User.accessTokens.create(user, ['*'], {
        expiresIn: '30 days',
        name: 'Signup Token',
      })

      return response.created({
        message: 'User created successfully',
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
        },
        token: token.value!.release(),
      })
    } catch (error) {
      return response.internalServerError({
        message: 'Failed to create user',
        error: error.message,
      })
    }
  }
}
