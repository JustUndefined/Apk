const express = require('express');
const jwt     = require('jsonwebtoken');
const fs      = require('fs');
const path    = require('path');
const router  = express.Router();

const JWT_SECRET  = process.env.JWT_SECRET || 'poolmaster_secret_2024';
const KEYLIST_PATH = path.join(__dirname, '../../keylist.json');

// Load daftar license key yang valid
function loadKeys() {
  try {
    return JSON.parse(fs.readFileSync(KEYLIST_PATH, 'utf8'));
  } catch {
    return { keys: [] };
  }
}

// POST /auth/login
// Body: { username, license_key }
router.post('/login', (req, res) => {
  const { username, license_key } = req.body;

  if (!username || !license_key) {
    return res.status(400).json({
      success: false,
      message: 'Username dan license key wajib diisi',
    });
  }

  const data = loadKeys();

  // Cek apakah key ada di daftar dan belum expired
  const keyEntry = data.keys.find(k =>
    k.key === license_key &&
    k.active === true &&
    (!k.expires || new Date(k.expires) > new Date())
  );

  if (!keyEntry) {
    return res.status(401).json({
      success: false,
      message: 'License key tidak valid atau sudah expired',
    });
  }

  // Generate JWT token berlaku 30 hari
  const token = jwt.sign(
    { username, key: license_key, role: keyEntry.role || 'user' },
    JWT_SECRET,
    { expiresIn: '30d' }
  );

  res.json({
    success: true,
    message: 'Login berhasil',
    token,
    user: { username, role: keyEntry.role || 'user' },
  });
});

module.exports = router;
