# MFU Borrow App

> A Flutter mobile application for asset borrowing and management at MFU.

## 🚀 Table of Contents

1. [About](#about)
2. [Features](#features)
3. [Tech Stack](#tech-stack)
4. [Getting Started](#getting-started)
5. [UI](#assets--images)

---

## 📖 About

Students, lecturers, and staff each have tailored experiences:

- **Students**
  - Request to borrow assets
  - View and manage their borrow history
- **Lecturers**
  - Approve or reject borrow requests
- **Staff**
  - Create, edit, and manage assets
  - View dashboard with analytics

---

## ✨ Features

- Server­-side pagination
- Filters (by asset type, status, date)
- Full­-text search
- Role­-based authentication & authorization

---

## 🛠 Tech Stack

- **Flutter & Dart** – Mobile front­end
- **Node.js & Express** – RESTful API server
- **MySQL** – Relational database
- **JWT** – Secure stateless authentication
- **Cloudinary** - Image Upload

---

## 🚀 Getting Started

1. **Clone the repo**

   ```bash
   git clone https://github.com/yourusername/mfu_borrow.git
   cd mfu_borrow
   ```

2. \*_Install Dependencies_

   ```bash
   flutter pub get
   ```

   ```bash
   cd server
   npm install
   ```

3. Configure environment
   Copy .env.example to .env in server/ and set your DB and JWT secrets.

4. Run the server

   ```bash
   cd server
   npm run dev
   ```

5. Run the app

   ```bash
   cd ..
   flutter run
   ```

## 📲 UI

![App Home Screen](https://console.cloudinary.com/app/c-3c24cdc26a49adc2c11fb0ab08d637/assets/media_library/folders/cc18de61a889325cbae5c5936dc3c64867?view_mode=mosaic)

![Borrow Screen](https://console.cloudinary.com/app/c-3c24cdc26a49adc2c11fb0ab08d637/assets/media_library/folders/cc18de61a889325cbae5c5936dc3c64867?view_mode=mosaic)

![Manage Asset For Student Screen](https://console.cloudinary.com/app/c-3c24cdc26a49adc2c11fb0ab08d637/assets/media_library/folders/cc18de61a889325cbae5c5936dc3c64867?view_mode=mosaic)

![Create Asset Screen](https://console.cloudinary.com/app/c-3c24cdc26a49adc2c11fb0ab08d637/assets/media_library/folders/cc18de61a889325cbae5c5936dc3c64867?view_mode=mosaic)

![Manage Asset for Staff Screen](https://console.cloudinary.com/app/c-3c24cdc26a49adc2c11fb0ab08d637/assets/media_library/folders/cc18de61a889325cbae5c5936dc3c64867?view_mode=mosaic)

![Manage Asset for Lecturer Screen](https://console.cloudinary.com/app/c-3c24cdc26a49adc2c11fb0ab08d637/assets/media_library/folders/cc18de61a889325cbae5c5936dc3c64867?view_mode=mosaic)

![History Screen](https://console.cloudinary.com/app/c-3c24cdc26a49adc2c11fb0ab08d637/assets/media_library/folders/cc18de61a889325cbae5c5936dc3c64867?view_mode=mosaic)

![Dashboard](https://console.cloudinary.com/app/c-3c24cdc26a49adc2c11fb0ab08d637/assets/media_library/folders/cc18de61a889325cbae5c5936dc3c64867?view_mode=mosaic)

![Profile Page](https://console.cloudinary.com/app/c-3c24cdc26a49adc2c11fb0ab08d637/assets/media_library/folders/cc18de61a889325cbae5c5936dc3c64867?view_mode=mosaic)
