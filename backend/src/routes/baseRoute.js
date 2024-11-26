import { Router } from 'express';
const router = Router();

// Route de base
router.get('/', (req, res) => {
  res.send('SpotCast backend is running!');
});

export default router;
