require('dotenv').config();
const express    = require('express');
const cors       = require('cors');
const helmet     = require('helmet');
const morgan     = require('morgan');
const rateLimit  = require('express-rate-limit');
const fs         = require('fs');
const path       = require('path');

const authRoutes    = require('./src/routes/auth');
const cheatRoutes   = require('./src/routes/cheat');
const overlayRoutes = require('./src/routes/overlay');
const logRoutes     = require('./src/routes/log');
const bypassRoutes  = require('./src/routes/bypass');

const app  = express();
const PORT = process.env.PORT || 3000;

// === SECURITY MIDDLEWARE ===
app.use(helmet());  // Set HTTP security headers

// Rate limiter — batasi request per IP agar tidak di-flood
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,  // 15 menit
  max: 100,                   // maks 100 req per window
  message: { success: false, message: 'Terlalu banyak request, coba lagi nanti' },
});
app.use(limiter);

// CORS — hanya izinkan request dari app
app.use(cors({
  origin: process.env.ALLOWED_ORIGIN || '*',
  methods: ['GET', 'POST'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-App-Key'],
}));

app.use(express.json({ limit: '1mb' }));
app.use(morgan('combined'));  // Log setiap request

// Validasi App-Key header di setiap request
app.use((req, res, next) => {
  const appKey = req.headers['x-app-key'];
  if (appKey !== 'poolmaster-v1') {
    return res.status(403).json({ success: false, message: 'Akses ditolak' });
  }
  next();
});

// === ROUTES ===
app.get('/ping', (req, res) => {
  // Endpoint health check — dicek APK saat splash
  res.json({ success: true, status: 'online', time: new Date().toISOString() });
});

app.use('/auth',    authRoutes);
app.use('/cheat',   cheatRoutes);
app.use('/overlay', overlayRoutes);
app.use('/log',     logRoutes);
app.use('/bypass',  bypassRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({ success: false, message: 'Endpoint tidak ditemukan' });
});

// Error handler global
app.use((err, req, res, next) => {
  console.error('[ERROR]', err.message);
  res.status(500).json({ success: false, message: 'Internal server error' });
});

app.listen(PORT, () => {
  console.log(`[•] Pool Master API running on port ${PORT}`);
  console.log(`[•] Ping: http://localhost:${PORT}/ping`);
});
