import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import db from '../../../models/index.js'; // Import du modèle principal

// Destructuration des modèles User et Role depuis db
const { User, Role } = db;

// Contrôleur pour l'inscription d'un utilisateur
export const registerUser = async (req, res) => {
  console.log('Route /users/register atteinte');
    console.log('Données reçues :', req.body);
  try {
    // Récupération et validation des données du body
    const { email, name, password } = req.body;
    if (!email || !name || !password) {
      return res.status(400).json({ message: 'All fields are required' });
    }

    // Log conditionnel pour le développement
    if (process.env.NODE_ENV === 'development') {
      console.log('Body received:', req.body);
      console.log('User modèle depuis le contrôleur :', User);
      console.log('Méthodes disponibles sur User :', Object.keys(User.prototype || {}));
    }

    // Vérification si l'utilisateur existe déjà
    const existingUser = await User.findOne({ where: { email } });
    if (existingUser) {
      return res.status(400).json({ message: 'Email is already registered' });
    }

    // Recherche du rôle utilisateur par défaut
    const defaultRole = await Role.findOne({ where: { name: 'user' } });
    if (!defaultRole) {
      return res.status(500).json({ message: 'Default user role not found' });
    }

    // Hashage du mot de passe
    const hashedPassword = await bcrypt.hash(password, 10);

    // Création de l'utilisateur dans la base de données
    const newUser = await User.create({
      email,
      name,
      password: hashedPassword,
      roleId: defaultRole.id,
    });

    // Génération d'un token JWT
    const payload = { id: newUser.id, role: defaultRole.name };
    const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '1h' });

    // Réponse au client
    return res.status(201).json({
      message: 'User registered successfully',
      user: {
        id: newUser.id,
        email: newUser.email,
        name: newUser.name,
        role: defaultRole.name,
      },
      token,
    });
  } catch (err) {
    console.error('Erreur lors de l\'inscription :', err);
    return res.status(500).json({ message: 'Server error' });
  }
};
