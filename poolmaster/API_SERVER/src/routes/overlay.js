const express    = require('express');
const authMiddle = require('../middleware/auth');
const router     = express.Router();

// POST /overlay/command — kirim perintah ke overlay
router.post('/command', authMiddle, (req, res) => {
  const { action, payload } = req.body;

  const validActions = ['toggle_esp', 'toggle_aimbot', 'set_sensitivity', 'reload'];

  if (!validActions.includes(action)) {
    return res.status(400).json({ success: false, message: 'Action tidak valid' });
  }

  // Di production, ini bisa forward ke WebSocket aktif user
  console.log(`[OVERLAY] User: ${req.user.username} | Action: ${action}`, payload);

  res.json({ success: true, action, received: true });
});

module.exports = router;
