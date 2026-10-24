const express    = require('express');
const authMiddle = require('../middleware/auth');
const fs         = require('fs');
const path       = require('path');
const router     = express.Router();

const LOG_PATH = path.join(__dirname, '../../logUser.txt');

// POST /log/event — catat aktivitas user
router.post('/event', authMiddle, (req, res) => {
  const { event, timestamp } = req.body;

  // Format log line
  const line = `[${timestamp || new Date().toISOString()}] ${req.user.username} | ${event}\n`;

  // Append ke log file
  fs.appendFile(LOG_PATH, line, (err) => {
    if (err) console.error('[LOG] Write error:', err.message);
  });

  res.json({ success: true });
});

module.exports = router;
