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

1. App Home Screen

![App Home Screen](https://res.cloudinary.com/dndkxuzes/image/upload/w_300,q_auto,c_fill/v1753181489/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2025-07-21_at_16.13.55_gqjl04.png)

2. Borrow Screen

![Borrow Screen](https://res.cloudinary.com/dndkxuzes/image/upload/w_300,q_auto,c_fill/v1753181490/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2025-07-21_at_16.14.27_uqmvae.png)

3. Manage Asset For Student Screen

![Manage Asset For Student Screen](https://res.cloudinary.com/dndkxuzes/image/upload/w_300,q_auto,c_fill/v1753181497/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2025-07-22_at_17.46.37_dczg8j.png)

4. Create Asset Screen

![Create Asset Screen](https://res.cloudinary.com/dndkxuzes/image/upload/w_300,q_auto,c_fill/v1753181496/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2025-07-22_at_17.08.02_r6nonn.png)

5. Manage Asset for Staff Screen

![Manage Asset for Staff Screen](https://res.cloudinary.com/dndkxuzes/image/upload/w_300,q_auto,c_fill/v1753181498/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2025-07-22_at_17.49.30_mm6u01.png)

6. Manage Asset for Lecturer Screen

![Manage Asset for Lecturer Screen](https://res.cloudinary.com/dndkxuzes/image/upload/w_300,q_auto,c_fill/v1753181498/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2025-07-22_at_17.49.30_mm6u01.png)

7. History Screen

![History Screen](https://res.cloudinary.com/dndkxuzes/image/upload/w_300,q_auto,c_fill/v1753181490/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2025-07-21_at_16.39.10_fv0dn4.png)

8. Dashboard

![Dashboard](https://res.cloudinary.com/dndkxuzes/image/upload/w_300,q_auto,c_fill/v1753181493/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2025-07-22_at_17.07.49_qkxypp.png)

9. Profile Page

![Profile Page](https://res.cloudinary.com/dndkxuzes/image/upload/w_300,q_auto,c_fill/v1753181492/Simulator_Screenshot_-_iPhone_15_Pro_Max_-_2025-07-22_at_16.58.20_dnabfy.png)
