import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';
import db from '../../../models/index.js'; // Import de tout db
const { User, Role } = db;

export const loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Vérification des champs
    if (!email || !password) {
      return res.status(400).json({ message: 'Email and password are required' });
    }

    // Recherche de l'utilisateur
    const user = await User.findOne({
      where: { email },
      include: [{ model: Role, as: 'role' }], // Associe le rôle de l'utilisateur
    });

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Vérification du mot de passe
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({ message: 'Invalid password' });
    }

    // Génération du token JWT
    const payload = { id: user.id, role: user.role.name };
    const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '1h' });

    // Réponse au client
    res.status(200).json({
      message: 'Login successful',
      token,
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role.name,
      },
    });
  } catch (error) {
    console.error('Error during login:', error);
    res.status(500).json({ message: 'Server error' });
  }
};
