import db from '../../../models/index.js';

const { User, Role } = db;

export const getUserProfile = async (req, res) => {
    console.log('Utilisateur connecté :', req.user);
  try {
    const userId = req.user.id; // L'ID est attaché par authenticateJWT

    // Rechercher l'utilisateur dans la base de données avec son rôle
    const user = await User.findByPk(userId, {
      include: [{ model: Role, as: 'role' }],
    });

    if (!user) {
      return res.status(404).json({ message: 'User not found.' });
    }

    // Réponse avec les données utilisateur
    res.status(200).json({
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role?.name || 'user',
    });
  } catch (error) {
    console.error('Error fetching user profile:', error);
    res.status(500).json({ message: 'Server error.' });
  }
};
