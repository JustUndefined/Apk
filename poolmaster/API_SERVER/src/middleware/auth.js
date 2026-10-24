const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'poolmaster_secret_2024';

// Middleware verifikasi JWT token
module.exports = (req, res, next) => {
  const authHeader = req.headers['authorization'];

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ success: false, message: 'Token tidak ada' });
  }

  const token = authHeader.split(' ')[1];

  try {
    // Verifikasi signature dan expiry token
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;  // Attach data user ke request
    next();
  } catch (err) {
    return res.status(401).json({ success: false, message: 'Token tidak valid' });
  }
};
