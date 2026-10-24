const express    = require('express');
const authMiddle = require('../middleware/auth');
const router     = express.Router();

// GET /cheat/config — ambil config cheat (perlu auth)
router.get('/config', authMiddle, (req, res) => {
  // Config ini bisa diupdate server-side tanpa update APK
  res.json({
    success: true,
    config: {
      angle_offset:     0.0,    // offset koreksi sudut jika meleset
      power_multiplier: 1.0,    // multiplier power tembak
      esp_color:        '00FF88', // warna garis ESP (hex)
      esp_thickness:    2,       // ketebalan garis
      pocket_radius:    12,      // radius deteksi pocket (px)
      bypass_version:   '2.1',   // versi bypass anti-cheat
      server_time:      new Date().toISOString(),
    },
  });
});

module.exports = router;
