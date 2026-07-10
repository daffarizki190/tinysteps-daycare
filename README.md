# TinySteps Day Care 🌿

Aplikasi mobile **Day Care Management** berbasis Flutter untuk memantau aktivitas harian anak di tempat penitipan anak (daycare). Proyek ini telah dikembangkan untuk memenuhi kriteria Ujian Akhir Semester (UAS) mata kuliah Mobile Computing.

---

## 🎨 Desain Figma

Lihat desain UI/UX lengkap proyek ini di Figma:

🔗 **[TinySteps Day Care – Figma Design](https://www.figma.com/design/hd6CDPav9NGpGdwteyOHPE/Day-Care?node-id=0-1&t=r9KMiv4ZGCuVLhDU-1)**

---

## 📱 Fitur Aplikasi (UAS Implementation)

Proyek ini telah dikembangkan dengan mengimplementasikan seluruh kriteria UAS:

1. **Software Architecture (MVC)**
   - Menerapkan arsitektur Feature-Based MVC.
   - Terdapat pemisahan yang jelas antara `models/`, `views/`, dan `controllers/`.
2. **State Management**
   - Menggunakan `Provider` (`ChangeNotifierProvider`) untuk manajemen state global (`AuthController` & `HomeController`).
3. **REST API Integration**
   - Menggunakan package `http` untuk menarik data dari `https://jsonplaceholder.typicode.com/posts`.
   - Data ditampilkan secara dinamis di halaman Tracker.
4. **Local Storage**
   - Menggunakan `shared_preferences` untuk menyimpan status autentikasi/login (`isLoggedIn`).
   - Apabila pengguna sudah login, aplikasi akan langsung diarahkan ke Home Page saat dibuka kembali.
5. **Mobile Feature (Camera)**
   - Menggunakan package `image_picker` (Camera Source).
   - Pengguna dapat mengetuk (tap) Avatar Profil di sudut kiri atas Home Page untuk membuka kamera perangkat dan mengganti foto profil.

---

## 🗂️ Struktur Proyek MVC

```
lib/
├── main.dart                          # Entry point (MultiProvider & Route Config)
├── core/
│   ├── theme/
│   └── utils/
└── features/
    ├── auth/
    │   ├── controllers/
    │   │   └── auth_controller.dart   # Logic login & shared_preferences
    │   └── views/
    │       └── login_page.dart        # Tampilan halaman login
    └── home/
        ├── controllers/
        │   └── home_controller.dart   # Logic fetch API REST
        ├── models/
        │   └── activity_model.dart    # Mapping JSON API ke Objek Dart
        └── views/
            └── home_page.dart         # Halaman utama dengan 5 tab & Camera Picker
```

---

## 🚀 Cara Menjalankan Proyek

### Prasyarat
- [Flutter SDK](https://flutter.dev/docs/get-started/install) versi **≥ 3.8.0**
- Android Studio / VS Code
- Emulator atau perangkat keras Android/iOS

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

### Akun Testing
| Field | Value |
|-------|-------|
| Email | `test` |
| Password | `test` |

---

## 🛠️ Package Tambahan (UAS)

| Package | Deskripsi |
|-----------|-------|
| `provider` | State Management MVC |
| `http` | REST API Client |
| `shared_preferences` | Penyimpanan Sesi Lokal |
| `image_picker` | Akses Kamera Perangkat |

---

## 👨‍💻 Pengembang

Proyek ini dikembangkan oleh **daffarizki190** sebagai tugas Ujian Akhir Semester (UAS) mata kuliah **Mobile Computing**.

---

*Dibangun dengan ❤️ menggunakan Flutter*
