import router from '@adonisjs/core/services/router'
import { middleware } from '#start/kernel'
import server from '@adonisjs/core/services/server'

import AuthController from '../app/controllers/auth_controller.js'
import UsersController from '../app/controllers/users_controller.js'

const API_PREFIX = '/api'

// Auth Routes
router.post(`${API_PREFIX}/auth/login`, [AuthController, 'login'])
router.post(`${API_PREFIX}/auth/logout`, [AuthController, 'logout']).middleware(middleware.auth())

// User Routes
router
  .group(() => {
    router.get('/users', [UsersController, 'index']).as('index') // Nom : users.index
    router.get('/users/:id', [UsersController, 'show']).as('show') // Nom : users.show
    router.patch('/users/:id', [UsersController, 'update']).as('update') // Nom : users.update
    router.delete('/users/:id', [UsersController, 'destroy']).as('destroy') // Nom : users.destroy
  })
  .prefix(API_PREFIX) // Utilisation de la constante API_PREFIX
  .as('users') // Préfixe les noms des routes avec "users."
  .use(middleware.auth())

// Public Routes
router.get('/', () => 'Welcome to SpotCast!')
router.get(API_PREFIX, () => {
  return { message: 'Welcome to the SpotCast API!' }
})

// Server Error Handler
server.errorHandler(async ({ response, error }) => {
  if (error.status === 404) {
    response.status(404).send({ message: 'Route not found' })
  } else {
    response.status(error.status || 500).send({
      message: 'Internal server error',
      error: error.message,
    })
  }
})
