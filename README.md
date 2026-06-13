# TinySteps Day Care 🌿

Aplikasi mobile **Day Care Management** berbasis Flutter untuk memantau aktivitas harian anak di tempat penitipan anak (daycare). Orang tua dapat memantau status anak, jadwal harian, dan live camera kelas secara real-time.

---

## 🎨 Desain Figma

Lihat desain UI/UX lengkap proyek ini di Figma:

🔗 **[TinySteps Day Care – Figma Design](https://www.figma.com/design/hd6CDPav9NGpGdwteyOHPE/Day-Care?node-id=0-1&t=r9KMiv4ZGCuVLhDU-1)**

---

## 📱 Fitur Aplikasi

### 🔐 Halaman Login
- Tampilan modern dengan animasi slide-in `bounceOut`
- Validasi form email dan password
- Shortcut login cepat (`test` / `test`)
- Tombol Login with Biometrics
- Judul halaman: **"Hello, Parents!"**

### 🏠 Halaman Utama (Home Tab)
- **Liam's Status Card** – Menampilkan status anak (sedang tidur siang), progress bar, dan estimasi bangun
- **Quick Actions** – Tombol cepat: Check-in, Meals, Activities, Photos
- **Upcoming Schedule** – Jadwal aktivitas berikutnya (Lunch Time, Outdoor Play)

### 📊 Fitur Utama (Tracker Tab)
- **Live Camera Feed** – Selector kelas (Classroom A/B/Playground) dengan preview live feed dan badge `● LIVE`
- **Daily Tracker Timeline** – Timeline vertikal aktivitas harian anak dengan ikon dan tag status

### 🗂️ Navigasi 5 Tab
| Tab | Label | Ikon |
|-----|-------|------|
| 0 | Home | `home_rounded` |
| 1 | Tracker | `analytics_rounded` |
| 2 | Photos | `camera_alt_rounded` |
| 3 | Messages | `chat_bubble_outline_rounded` |
| 4 | Profile | `person_outline_rounded` |

---

## 🗂️ Struktur Proyek

```
lib/
├── main.dart                          # Entry point aplikasi
├── core/
│   ├── theme/
│   │   └── app_colors.dart            # Token warna global
│   └── utils/
│       └── utils.dart                 # Utility validasi
└── features/
    ├── auth/
    │   └── login_page.dart            # Halaman Login
    └── home/
        ├── home_page.dart             # Halaman Utama (5 tab)
        ├── data/
        │   └── daily_tracker_data.dart # Data JSON aktivitas harian
        └── widgets/
            ├── home_header.dart        # Widget header + summary chips
            ├── tracker_item_card.dart  # Kartu item Daily Tracker (animasi staggered)
            └── home_bottom_nav_bar.dart # Custom Bottom Navigation Bar
```

---

## 🚀 Cara Menjalankan Proyek

### Prasyarat
- [Flutter SDK](https://flutter.dev/docs/get-started/install) versi **≥ 3.8.0**
- Android Studio / VS Code
- Emulator atau perangkat Android/iOS

### Langkah Instalasi

```bash
# 1. Clone repository
git clone <URL_REPOSITORY_ANDA>
cd Day_Care

# 2. Install dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run
```

### Login Akun Testing
| Field | Value |
|-------|-------|
| Email | `test` |
| Password | `test` |

---

## 🛠️ Teknologi yang Digunakan

| Teknologi | Versi |
|-----------|-------|
| Flutter | ≥ 3.8.0 |
| Dart | ≥ 3.0 |
| Material Design 3 | ✅ |

### Package yang Digunakan
- `cupertino_icons` ^1.0.8 – Ikon gaya iOS

---

## 🎨 Palet Warna

| Nama | Hex |
|------|-----|
| Primary Green | `#85B38B` |
| Primary Green Dark | `#5E8C64` |
| Primary Green Light | `#E2EFE5` |
| Background | `#F7FAF8` |
| Text Primary | `#1A1A2E` |
| Text Secondary | `#6B7280` |

---

## 📚 Materi yang Diimplementasikan

- ✅ **Pertemuan 5** – Animasi slide `bounceOut` pada Login Page
- ✅ **Pertemuan 6** – JSON Data, `ListView.builder`, Navigation Bar, Staggered Animation

---

## 👨‍💻 Pengembang

Proyek ini dikembangkan sebagai tugas mata kuliah **Mobile Computing**.

---

*Dibangun dengan ❤️ menggunakan Flutter*
