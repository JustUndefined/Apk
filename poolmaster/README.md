# POOL MASTER — 8Ball Pool Cheat Tool
### Panduan Lengkap: Deploy API → Build APK → Pakai

---

## STRUKTUR PROJECT

```
poolmaster/
├── BASE_APK/          ← Source Flutter (di-build jadi APK)
├── API_SERVER/        ← Backend Node.js (deploy ke VPS)
└── README.md
```

---

## STEP 1 — DEPLOY API SERVER

API harus online dulu sebelum APK bisa login.

### Cara deploy di VPS (Railway / Render / VPS biasa):

**Railway (gratis, paling mudah):**
1. Buka https://railway.app → New Project → Deploy from GitHub
2. Upload folder `API_SERVER/` ke GitHub dulu
3. Railway auto-detect Node.js dan langsung deploy
4. Copy URL project Railway (contoh: `https://poolmaster.up.railway.app`)

**VPS Manual:**
```bash
# Upload folder API_SERVER ke VPS
scp -r API_SERVER/ user@IP_VPS:/home/user/

# Di VPS:
cd API_SERVER
npm install
npm start

# Atau pakai PM2 agar tetap jalan:
npm install -g pm2
pm2 start index.js --name poolmaster-api
pm2 save
pm2 startup
```

**Setelah deploy**, cek server hidup:
```
GET https://url-server-kamu/ping
→ {"success":true,"status":"online"}
```

---

## STEP 2 — GANTI URL SERVER DI APK

Buka file:
```
BASE_APK/lib/core/app_state.dart
```

Cari baris ini dan ganti URL-nya:
```dart
String _serverUrl = 'https://your-api-server.com'; // ganti ini
```
Jadi:
```dart
String _serverUrl = 'https://url-server-kamu.railway.app'; // URL Railway/VPS kamu
```

---

## STEP 3 — BUILD APK

### Cara 1: Telegram APK Builder (paling mudah, tidak perlu PC)

1. Zip folder `BASE_APK/` jadi `BASE_APK.zip`
2. Cari bot Telegram: `@ApkBuilderBot` atau `@FlutterBuilderBot`
3. Send ZIP ke bot
4. Tunggu beberapa menit
5. Bot kirim balik file `.apk`

### Cara 2: Build manual di PC (perlu Flutter SDK)

```bash
# Install Flutter: https://flutter.dev/docs/get-started/install

cd BASE_APK
flutter pub get
flutter build apk --release

# APK ada di:
# BASE_APK/build/outputs/flutter-apk/app-release.apk
```

---

## STEP 4 — INSTALL APK DI HP

1. Transfer APK ke HP (via kabel / Google Drive / Telegram)
2. Buka file APK di HP
3. Kalau muncul "Sumber tidak dikenal" → Izinkan
4. Install selesai

---

## STEP 5 — CARA PAKAI

**Pertama kali:**
1. Buka app **Pool Master**
2. Pastikan status server **ONLINE** (dot hijau)
3. Login dengan:
   - Username: bebas (nama apapun)
   - License Key: `PM01-TEST-DEMO-0001` (key demo)
4. Kamu masuk ke halaman utama

**Saat mau main:**
1. Aktifkan toggle **ESP** dan **Auto-Aim**
2. Pastikan **Bypass Anti-Cheat** aktif
3. Atur sensitivitas aim sesuai selera (85% recommended)
4. Tap **"AKTIFKAN OVERLAY"**
5. Muncul popup izin — tap **Izinkan**
6. App otomatis minimize
7. Buka **8Ball Pool**
8. Panel kecil hijau muncul di pojok layar = overlay aktif
9. Tap panel untuk expand info angle & power
10. Tap lagi untuk collapse

**Toggle di overlay:**
- **ESP** = garis tembak
- **AIM** = auto-aim aktif/nonaktif

---

## TAMBAH LICENSE KEY

Edit file `API_SERVER/keylist.json`:
```json
{
  "keys": [
    {
      "key": "PM01-XXXX-YYYY-0001",
      "active": true,
      "role": "user",
      "expires": "2025-12-31",
      "note": "Key untuk user A"
    }
  ]
}
```
Format key bebas, yang penting unik.

---

## TROUBLESHOOT

| Masalah | Solusi |
|---|---|
| Server Offline | Cek URL di `app_state.dart`, pastikan VPS hidup |
| Login gagal | Cek key di `keylist.json`, pastikan `active: true` |
| Overlay tidak muncul | Setting HP → App → Pool Master → Izin → Tampil di atas app → ON |
| APK tidak bisa install | Aktifkan "Sumber tidak dikenal" di pengaturan HP |
| Overlay tertutup sendiri | HP kamu agresif kill background app, buka Battery → Pool Master → Tidak dibatasi |

---

## CATATAN

- Key demo `PM01-TEST-DEMO-0001` expired 31 Des 2025
- Ganti `JWT_SECRET` di `.env` dengan string random panjang sebelum production
- Untuk tambah user baru, tambah key baru di `keylist.json` (tidak perlu restart server)
