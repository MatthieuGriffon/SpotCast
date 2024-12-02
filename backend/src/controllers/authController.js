import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';
import { User, Role } from '../../models/index.js'; // Import explicite des modèles
import { validate as isUuid } from 'uuid';

export const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    // Vérification des champs
    if (!email || !password) {
      return res.status(400).json({ message: 'Email and password are required' });
    }
    // Recherche de l'utilisateur avec son rôle
    const user = await User.findOne({
      where: { email },
      include: [{ model: Role, as: 'role' }], // Associer le modèle `Role`
    });
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    // Vérifie le mot de passe
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid password' });
    }
    // Génération des tokens
    const payload = { id: user.id, role: user.role.name };
    const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '1h' });
    const refreshToken = jwt.sign({ id: user.id }, process.env.JWT_REFRESH_SECRET, { expiresIn: '7d' });
    // Sauvegarde du refresh token
    await user.update({ refreshToken });
    // Réponse au client
    res.status(200).json({
      message: 'Login successful',
      token,
      refreshToken,
      user: {
        id: user.id,
        email: user.email,
        role: user.role.name,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

export const refreshTokenHandler = async (req, res) => {
  const { refreshToken } = req.body;

  if (!refreshToken) {
    return res.status(400).json({ message: 'Refresh Token is required' });
  }

  try {
    const payload = verifyRefreshToken(refreshToken);

    // Rechercher l'utilisateur
    const user = await User.findOne({ where: { id: payload.id, refreshToken } });
    if (!user) {
      return res.status(403).json({ message: 'Invalid Refresh Token' });
    }

    // Générer de nouveaux tokens
    const newAccessToken = generateAccessToken(user);
    const newRefreshToken = generateRefreshToken(user);

    // Mettre à jour le Refresh Token dans la base de données
    await user.update({ refreshToken: newRefreshToken });

    // Renvoyer les nouveaux tokens
    res.status(200).json({ accessToken: newAccessToken, refreshToken: newRefreshToken });
  } catch (error) {
    console.error('Error refreshing token:', error);
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ message: 'Refresh Token has expired' });
    }
    res.status(403).json({ message: 'Invalid Refresh Token' });
  }
};

export const logout = async (req, res) => {
  try {
    const { userId } = req.body;

    // Vérifie si l'ID utilisateur est fourni
    if (!userId) {
      return res.status(400).json({ message: 'User ID is required' });
    }

    // Vérifie si l'ID est un UUID valide
    if (!isUuid(userId)) {
      return res.status(400).json({ message: 'Invalid User ID format' });
    }

    // Trouve l'utilisateur et réinitialise son refresh token
    const user = await User.findByPk(userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    await user.update({ refreshToken: null });

    return res.status(200).json({ message: 'Logout successful' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error' });
  }
};
