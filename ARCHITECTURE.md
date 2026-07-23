# TinySteps Day Care — System Architecture

## Overview

TinySteps Day Care adalah aplikasi mobile berbasis Flutter yang mengikuti arsitektur MVC (Model-View-Controller) dengan state management menggunakan Provider. Aplikasi ini didesain untuk menghubungkan orang tua dengan aktivitas anak mereka di daycare.

## Architecture Diagram

```
┌───────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                  │
│  ┌─────────┐ ┌──────────┐ ┌────────┐ ┌───────────┐   │
│  │  Home   │ │  Photos  │ │Messages│ │  Profile  │   │
│  │  Tab    │ │  Tab     │ │  Tab   │ │   Tab     │   │
│  └────┬────┘ └────┬─────┘ └───┬────┘ └─────┬─────┘   │
│       └───────────┴───────────┴─────────────┘         │
│                        │                               │
│  ┌─────────────────────┴────────────────────────────┐ │
│  │              STATE MANAGEMENT (Provider)          │ │
│  │  HomeCtrl │ PhotosCtrl │ MessagesCtrl │ ProfileCtrl│ │
│  └─────────────────────┬────────────────────────────┘ │
└────────────────────────┼──────────────────────────────┘
                         │
┌────────────────────────┼──────────────────────────────┐
│                    SERVICE LAYER                       │
│  ┌──────────────┐ ┌─────────────┐ ┌────────────────┐ │
│  │  API Service │ │  Auth Guard │ │  Data Scope    │ │
│  │  (Layer 2)   │ │  (Layer 4)  │ │  RLS (Layer 8) │ │
│  └──────┬───────┘ └──────┬──────┘ └───────┬────────┘ │
│         │                │                │           │
│  ┌──────┴───────┐ ┌──────┴──────┐ ┌───────┴────────┐ │
│  │ Rate Limiter │ │ Cache Mgr   │ │ Connectivity   │ │
│  │  (Layer 9)   │ │ (Layer 10)  │ │   (Bonus)      │ │
│  └──────────────┘ └─────────────┘ └────────────────┘ │
│                                                        │
│  ┌──────────────┐ ┌─────────────┐ ┌────────────────┐ │
│  │ Logger Svc   │ │ Error Hndlr │ │ Backup Service │ │
│  │  (Layer 12)  │ │ (Layer 12)  │ │   (Bonus)      │ │
│  └──────────────┘ └─────────────┘ └────────────────┘ │
└────────────────────────┼──────────────────────────────┘
                         │
┌────────────────────────┼──────────────────────────────┐
│                    DATA LAYER                          │
│  ┌──────────────┐ ┌─────────────┐ ┌────────────────┐ │
│  │ Database     │ │  Secure     │ │  SharedPrefs   │ │
│  │ Helper       │ │  Storage    │ │                │ │
│  │ (Layer 3)    │ │  (Layer 3)  │ │  (Layer 3)     │ │
│  └──────────────┘ └─────────────┘ └────────────────┘ │
└────────────────────────┼──────────────────────────────┘
                         │
┌────────────────────────┼──────────────────────────────┐
│                  EXTERNAL SERVICES                     │
│  ┌──────────────┐ ┌─────────────┐                     │
│  │  MockAPI.io  │ │  Device     │                     │
│  │  REST API    │ │  Camera     │                     │
│  │  (Cloud)     │ │  Gallery    │                     │
│  └──────────────┘ └─────────────┘                     │
└───────────────────────────────────────────────────────┘
```

## API Endpoints (MockAPI.io)

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/user` | Ambil semua users |
| POST | `/user` | Register user baru |
| GET | `/user?email=X&password=Y` | Login user |
| GET | `/activities` | Ambil daftar aktivitas |
| POST | `/activities` | Tambah aktivitas baru |
| GET | `/photos` | Ambil daftar foto |
| POST | `/photos` | Upload foto baru |
| GET | `/messages` | Ambil pesan |
| POST | `/messages` | Kirim pesan |

## Data Flow

```
User Action → View (Widget)
    → Controller (ChangeNotifier)
        → API Service (HTTP + interceptors)
            → Rate Limiter (check quota)
            → Auth Guard (inject token)
            → Cache Manager (check cache)
                → MockAPI.io / Local Storage
        ← Response
    ← Controller updates state
← View rebuilds via Consumer<T>
```

## Technology Stack

| Layer | Technology | Tujuan |
|-------|-----------|--------|
| Language | Dart 3.x | Core programming language |
| Framework | Flutter 3.x | Cross-platform UI framework |
| State Management | Provider | Reactive state management |
| HTTP Client | http package | REST API communication |
| Secure Storage | flutter_secure_storage | Encrypted credential storage |
| Local Storage | SharedPreferences | Key-value persistent storage |
| Camera | image_picker | Device camera & gallery access |
| Biometrics | local_auth | Fingerprint/Face ID authentication |

## Cloud Migration Path

Saat ini backend menggunakan **MockAPI.io** untuk prototyping. Untuk production, pertimbangkan migrasi ke:

1. **Firebase** — Auth, Firestore, Storage, Cloud Functions
2. **Supabase** — PostgreSQL, Auth, Storage, Real-time
3. **Custom Backend** — Node.js/Go + PostgreSQL + Docker

### Migration Steps:
1. Ganti `ApiConfig.baseUrl` ke production server
2. Update `AuthController` untuk menggunakan Firebase Auth / Supabase Auth
3. Migrasi `DatabaseHelper` ke Firestore / Supabase tables
4. Setup Cloud Functions untuk business logic (activities summary, notifications)

## Scaling Strategy (Layer 11)

| Aspek | Strategi Mobile | Strategi Backend |
|-------|-----------------|------------------|
| Data Loading | Pagination (20 items/page) | Database indexing |
| Image | Thumbnail + lazy load | CDN (CloudFlare/Cloudinary) |
| Cache | In-memory TTL (5 min) | Redis/Memcached |
| Offline | SQLite/SharedPrefs sync | Event queue + retry |
| Concurrent | Max 6 HTTP requests | Load balancer (Nginx) |
