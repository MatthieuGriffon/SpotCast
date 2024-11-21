import { errors } from '@adonisjs/core'
import { HttpContext, ExceptionHandler } from '@adonisjs/core/http'
import logger from '@adonisjs/core/services/logger'
import { errors as authErrors } from '@adonisjs/auth'
import { errors as bouncerErrors } from '@adonisjs/bouncer'

export default class HttpExceptionHandler extends ExceptionHandler {
  /**
   * Activer les stack traces détaillées en mode debug si l'application n'est pas en production.
   */
  protected debug = process.env.NODE_ENV !== 'production'

  /**
   * Gérer les exceptions et envoyer une réponse au client.
   */
  async handle(error: unknown, ctx: HttpContext) {
    const { response } = ctx

    // Erreur : route non trouvée
    if (error instanceof errors.E_ROUTE_NOT_FOUND) {
      return response.status(404).send({
        message: 'Route not found',
        status: 404,
      })
    }

    // Erreur : accès non autorisé
    if (error instanceof authErrors.E_UNAUTHORIZED_ACCESS) {
      return response.status(401).send({
        message: 'Unauthorized access',
        status: 401,
      })
    }

    // Erreur : échec d'authentification
    if (error instanceof authErrors.E_INVALID_CREDENTIALS) {
      return response.status(400).send({
        message: 'Invalid credentials',
        status: 400,
      })
    }

    // Erreur : échec de validation des autorisations
    if (error instanceof bouncerErrors.E_AUTHORIZATION_FAILURE) {
      return response.status(403).send({
        message: 'Authorization failure',
        status: 403,
      })
    }

    // Par défaut pour toutes les autres erreurs HTTP
    if (error instanceof errors.E_HTTP_EXCEPTION) {
      return response.status(error.status).send({
        message: error.message || 'An error occurred',
        status: error.status || 500,
        stack: this.debug ? error.stack : undefined,
      })
    }

    // Gestion des erreurs inconnues (fallback)
    if (error instanceof Error) {
      return response.status(500).send({
        message: 'Internal server error',
        status: 500,
        stack: this.debug ? error.stack : undefined,
      })
    }

    // En cas d'erreur non compatible avec `Error`
    return response.status(500).send({
      message: 'An unknown error occurred',
      status: 500,
    })
  }

  /**
   * Ajout de contexte pour enrichir les logs d'erreur.
   */
  protected context(ctx: HttpContext) {
    return {
      userId: ctx.auth?.user?.id,
      ip: ctx.request.ip(),
      url: ctx.request.url(),
      method: ctx.request.method(),
    }
  }

  /**
   * Rapport d'erreurs (log)
   */
  async report(error: unknown, ctx: HttpContext) {
    const context = this.context(ctx)

    // Vérification pour HttpError-like (status + message)
    if (this.isHttpError(error)) {
      const httpError = error as { status: number; message: string; stack?: string }
      const logLevel = this.getLogLevel(httpError.status)

      if (logLevel) {
        logger[logLevel]({
          ...context,
          message: httpError.message,
          stack: this.debug ? httpError.stack : undefined,
          status: httpError.status,
        })
        return
      }
    }

    // Gestion des erreurs standards (Error)
    if (error instanceof Error) {
      logger.error({
        ...context,
        message: error.message,
        stack: this.debug ? error.stack : undefined,
      })
    } else {
      // Gestion des erreurs inconnues (non standard)
      logger.error('Unknown error occurred', { ...context, error })
    }
  }

  /**
   * Obtenir le niveau de log en fonction du statut HTTP
   */
  private getLogLevel(status: number): 'error' | 'warn' | 'info' | null {
    if (status >= 500) return 'error'
    if (status >= 400) return 'warn'
    if (status >= 200) return 'info'
    return null
  }

  /**
   * Vérifie si l'erreur est un HttpError-like
   */
  private isHttpError(
    error: unknown
  ): error is { status: number; message: string; stack?: string } {
    return typeof error === 'object' && error !== null && 'status' in error && 'message' in error
  }
}
