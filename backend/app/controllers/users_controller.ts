import { HttpContext } from '@adonisjs/core/http'
import User from '../models/user.js'

export default class UsersController {
  /**
   * Récupérer la liste de tous les utilisateurs.
   * GET /api/users
   */
  public async index({ response }: HttpContext) {
    try {
      const users = await User.all()
      return response.ok(users)
    } catch (error) {
      return response.internalServerError({
        message: 'Failed to fetch users',
        error: error.message,
      })
    }
  }

  /**
   * Récupérer les détails d'un utilisateur spécifique.
   * GET /api/users/:id
   */
  public async show({ params, response }: HttpContext) {
    try {
      const user = await User.find(params.id)
      if (!user) {
        return response.notFound({ message: 'User not found' })
      }
      return response.ok(user)
    } catch (error) {
      return response.internalServerError({
        message: 'Failed to fetch user',
        error: error.message,
      })
    }
  }

  /**
   * Mettre à jour les informations d'un utilisateur.
   * PATCH /api/users/:id
   */
  public async update({ params, request, response }: HttpContext) {
    try {
      const user = await User.find(params.id)
      if (!user) {
        return response.notFound({ message: 'User not found' })
      }

      const data = request.only(['name', 'bio', 'photo'])
      user.merge(data)
      await user.save()
      return response.ok(user)
    } catch (error) {
      return response.internalServerError({
        message: 'Failed to update user',
        error: error.message,
      })
    }
  }

  /**
   * Supprimer un utilisateur.
   * DELETE /api/users/:id
   */
  public async destroy({ params, response }: HttpContext) {
    try {
      const user = await User.find(params.id)
      if (!user) {
        return response.notFound({ message: 'User not found' })
      }

      await user.delete()
      return response.ok({ message: 'User deleted successfully' })
    } catch (error) {
      return response.internalServerError({
        message: 'Failed to delete user',
        error: error.message,
      })
    }
  }
}
