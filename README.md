# Medical care Pharmacy 💊

A full-stack pharmacy store landing page with an admin panel, built as a Flutter Developer assignment.

![Flutter](https://img.shields.io/badge/Flutter-Web-02569B?logo=flutter)
![Node.js](https://img.shields.io/badge/Backend-Node.js%2FExpress-339933?logo=node.js)

---

## 🏗️ Architecture

```
assignment_omway/
├── assignmet_omway/     ← Flutter Web frontend
│   └── lib/
│       ├── core/        ← Theme, API client, constants
│       ├── models/      ← Product, Testimonial, ContactMessage
│       ├── services/    ← HTTP API services
│       ├── providers/   ← ChangeNotifier state management
│       └── features/
│           ├── landing/ ← Public landing page (7 sections)
│           └── admin/   ← Admin panel (CRUD)
└── backend/             ← Node.js/Express REST API
    ├── server.js
    ├── package.json
    ├── models/          ← Mongoose Models (Product, Testimonial, Contact)
    └── .env             ← Environment variables (MongoDB URI)
```

---

## ⚡ Tech Stack

| Layer | Tech |
|---|---|
| Frontend | Flutter Web |
| State Management | Provider (ChangeNotifier) |
| HTTP | `http` package |
| Animations | `flutter_animate` |
| Typography | Google Fonts (Inter) |
| Backend | Node.js + Express |
| Database | MongoDB Atlas (Mongoose) |

---

## 🚀 Setup & Running

### Prerequisites
- Flutter SDK ≥ 3.12.2
- Node.js ≥ 18.x
- Chrome browser

---

### Step 1 — Start the Backend API

```bash
cd backend
npm install
```

Create a `.env` file in the `backend` folder and add your MongoDB connection string (see `.env.example`):
```env
MONGODB_URI=mongodb+srv://<username>:<password>@cluster0...
JWT_SECRET=super-secret-admin-key-omway
PORT=3000
```

Start the server:
```bash
npm start
```

The API will start at **http://localhost:3000**

Verify: http://localhost:3000/api/health

---

### Step 2 — Run the Flutter Web App

```bash
cd assignmet_omway
flutter pub get
flutter run -d chrome
```

The app opens in Chrome at **http://localhost:PORT**

---

## 🗺️ Routes

| URL | Description |
|---|---|
| `/` | Public landing page |
| `/admin` | Admin panel |

---

## 📄 API Endpoints

### Products
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/products` | Get all products |
| GET | `/api/products/:id` | Get product by ID |
| POST | `/api/products` | Create product |
| PUT | `/api/products/:id` | Update product |
| DELETE | `/api/products/:id` | Delete product |

### Testimonials
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/testimonials` | Get all testimonials |
| POST | `/api/testimonials` | Create testimonial |
| PUT | `/api/testimonials/:id` | Update testimonial |
| DELETE | `/api/testimonials/:id` | Delete testimonial |

### Contacts
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/contacts` | Get all contact messages |
| POST | `/api/contacts` | Submit contact form |
| PUT | `/api/contacts/:id/read` | Mark as read |
| DELETE | `/api/contacts/:id` | Delete message |

### Other
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/stats` | Dashboard statistics |
| GET | `/api/health` | Health check |

---

## 🏪 Landing Page Sections

1. **Header** — Sticky navigation, scroll-aware styling, mobile menu
2. **Hero** — Full-screen gradient with animated stats and floating cards
3. **About** — Mission statement with stat tiles (15+ yrs, 500+ products, 50K+ customers)
4. **Featured Products** — 4 featured products in a responsive grid from API
5. **Testimonials** — Desktop grid / mobile carousel with star ratings
6. **Contact Form** — Validated form POSTing to the API
7. **Footer** — Links, newsletter, social icons

---

## 🛡️ Admin Panel (`/admin`)

- **Dashboard** — Live stats (products count, testimonials, unread messages)
- **Products** — Full CRUD with search, image thumbnails, featured toggle
- **Testimonials** — Full CRUD with star rating builder
- **Messages** — View, mark as read, delete. Unread badge in sidebar.

---

## 📦 Seeded Data

- **6 Products** (4+ featured): Paracetamol, OmegaShield Fish Oil, VitaBoost Multivitamin, BandAid Kit, Cough Syrup Plus, and more added via admin
- **4 Testimonials**: Sarah Mitchell, Raj Kumar, Priya Sharma, and more added via admin

---

## 🔐 Admin Credentials

| Field | Value |
|---|---|
| Username | `admin` |
| Password | `password123` |

---

## 📱 Responsive Design

- Desktop: Multi-column layout, sidebar admin navigation
- Mobile: Single column, drawer navigation, carousel testimonials