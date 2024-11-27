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

export const refreshToken = async (req, res) => {
  try {
    const { refreshToken } = req.body;

    if (!refreshToken) {
      return res.status(400).json({ message: 'Refresh token is required' });
    }

    // Vérification de la validité du refresh token
    const decoded = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET);

    // Vérifie l'existence de l'utilisateur et du refresh token
    const user = await User.findByPk(decoded.id, {
      include: [{ model: Role, as: 'role' }], // Inclusion explicite du rôle
    });

    if (!user || user.refreshToken !== refreshToken) {
      return res.status(401).json({ message: 'Invalid refresh token' });
    }

    // Génération d'un nouveau JWT
    const newToken = jwt.sign({ id: user.id, role: user.role.name }, process.env.JWT_SECRET, { expiresIn: '1h' });

    res.status(200).json({ token: newToken });
  } catch (error) {
    console.error(error);
    res.status(403).json({ message: 'Invalid or expired refresh token' });
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
