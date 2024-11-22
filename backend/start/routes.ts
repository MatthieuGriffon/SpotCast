import router from '@adonisjs/core/services/router'
const UsersController = () => import('../app/controllers/users_controller.js')

console.log('Routes initialized')
router
  .group(() => {
    router.post('/users', [UsersController, 'store']).as('users.store')
    // Ajoutez d'autres routes API ici
  })
  .prefix('/api')
