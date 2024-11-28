import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';
import db from '../../../models/index.js'; // Import de la base de données et des modèles

const { User } = db; // Destructuration pour accéder directement au modèle User

// Envoi de la demande de réinitialisation
export const requestPasswordReset = async (req, res) => {
  const { email } = req.body;

  try {
    // Vérification de l'email
    if (!email || typeof email !== 'string') {
      return res.status(400).json({ message: 'Valid email is required' });
    }

    // Vérification si l'utilisateur existe
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Générer un token de réinitialisation
    const resetToken = jwt.sign(
      { id: user.id, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: '15m' } // Valable 15 minutes
    );

    // Simuler l'envoi de l'email (afficher le lien dans la console pour les tests)
    console.log(`Password reset link generated for ${email}`);

    res.status(200).json({
      message: 'Password reset link sent to your email',
      resetLink: `http://localhost:3000/password-reset?token=${resetToken}`, // Pour tests locaux
    });
  } catch (error) {
    console.error('Error during password reset request:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

// Réinitialisation du mot de passe
export const resetPassword = async (req, res) => {
  const { token, newPassword } = req.body;

  try {
    // Vérification des entrées
    if (!token || typeof token !== 'string') {
      return res.status(400).json({ message: 'Reset token is required' });
    }
    if (!newPassword || typeof newPassword !== 'string' || newPassword.length < 6) {
      return res.status(400).json({ message: 'New password must be at least 6 characters long' });
    }

    // Vérifier le token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // Vérifier l'utilisateur dans la base de données
    const user = await User.findByPk(decoded.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Hasher le nouveau mot de passe
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Mettre à jour le mot de passe de l'utilisateur
    await user.update({ password: hashedPassword });

    res.status(200).json({ message: 'Password reset successfully' });
  } catch (error) {
    console.error('Error during password reset:', error);

    if (error.name === 'TokenExpiredError') {
      return res.status(400).json({ message: 'Reset token has expired' });
    }

    res.status(500).json({ message: 'Server error' });
  }
};
