import jwt from 'jsonwebtoken';



// Vérifie que les clés secrètes sont définies
const checkSecrets = () => {
    if (!process.env.JWT_SECRET || !process.env.REFRESH_TOKEN_SECRET) {
      throw new Error('JWT secret keys are not defined in the environment variables');
    }
  };
// Générer un Access Token (valable 15 minutes)
export const generateAccessToken = (user) => {
    checkSecrets();
  return jwt.sign(
    { id: user.id, email: user.email, role: user.role?.name }, // Ajoute les informations pertinentes
    process.env.JWT_SECRET,
    { expiresIn: '15m' }
  );
};

// Générer un Refresh Token (valable 7 jours)
export const generateRefreshToken = (user) => {
    checkSecrets();
  return jwt.sign(
    { id: user.id, email: user.email },
    process.env.REFRESH_TOKEN_SECRET,
    { expiresIn: '7d' }
  );
};

// Vérifier un Refresh Token
export const verifyRefreshToken = (token) => {
    checkSecrets();
    return jwt.verify(token, process.env.REFRESH_TOKEN_SECRET);
  };

