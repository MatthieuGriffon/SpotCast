import User from '../models/user.js'
import hash from '@adonisjs/core/services/hash'
import { HttpContext } from '@adonisjs/core/http'

export default class AuthController {
  public async login({ request, response }: HttpContext) {
    const { email, password } = request.only(['email', 'password'])

    try {
      const user = await User.query().where('email', email).firstOrFail()

      if (user.password && !(await hash.verify(user.password, password))) {
        return response.unauthorized({ message: 'Invalid credentials' })
      }

      const token = await User.accessTokens.create(user, ['*'], {
        expiresIn: '30 days',
        name: 'Login Token',
      })

      return response.ok({
        message: 'Login successful',
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
        },
        token: token.value!.release(),
      })
    } catch (error) {
      return response.badRequest({ message: 'Login failed', error: error.message })
    }
  }

  public async logout({ auth, response }: HttpContext) {
    try {
      if (auth.user?.currentAccessToken) {
        await User.accessTokens.delete(auth.user, auth.user.currentAccessToken.identifier)
      }
      return response.ok({ message: 'Logged out successfully' })
    } catch (error) {
      return response.internalServerError({ message: 'Logout failed', error: error.message })
    }
  }
}
