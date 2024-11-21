import type { HttpContext } from '@adonisjs/core/http'

export default class AuthMiddleware {
  async handle(ctx: HttpContext, next: () => Promise<void>) {
    if (!ctx.auth.isAuthenticated) {
      return ctx.response.unauthorized({ message: 'You must be logged in' })
    }
    await next()
  }
}
