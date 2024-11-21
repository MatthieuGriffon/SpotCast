import { defineConfig, drivers } from '@adonisjs/core/hash'

export default defineConfig({
  default: 'scrypt', // Algorithme par défaut

  list: {
    scrypt: drivers.scrypt({
      cost: 16384,
      blockSize: 8,
      parallelization: 1,
      maxMemory: 33554432, // 32 MiB
      keyLength: 64,
      saltSize: 16, // Taille du sel
    }),

    // Décommentez pour utiliser Argon2
    // argon: drivers.argon2({
    //   variant: 'id',
    //   iterations: 3,
    //   memory: 65536,
    //   parallelism: 4,
    // }),

    // Décommentez pour utiliser Bcrypt
    // bcrypt: drivers.bcrypt({
    //   rounds: 10,
    //   saltSize: 16,
    // }),
  },
})
