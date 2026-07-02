const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');
const jwt = require('jsonwebtoken');

const app = express();
const PORT = process.env.PORT || 3000;
const DB_PATH = path.join(__dirname, 'data', 'db.json');
const JWT_SECRET = 'super-secret-admin-key-omway';

// ─── Middleware ────────────────────────────────────────────────────────────────
app.use(cors());
app.use(express.json());

// ─── DB Helpers ───────────────────────────────────────────────────────────────
function readDB() {
  const raw = fs.readFileSync(DB_PATH, 'utf-8');
  return JSON.parse(raw);
}

function writeDB(data) {
  fs.writeFileSync(DB_PATH, JSON.stringify(data, null, 2), 'utf-8');
}

// ─── Auth Middleware ──────────────────────────────────────────────────────────
function authMiddleware(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ success: false, message: 'Unauthorized: No token provided' });
  }

  const token = authHeader.split(' ')[1];
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(401).json({ success: false, message: 'Unauthorized: Invalid token' });
  }
}

// ─── Auth Routes ──────────────────────────────────────────────────────────────
app.post('/api/auth/login', (req, res) => {
  const { username, password } = req.body;
  if (username === 'admin' && password === 'password123') {
    const token = jwt.sign({ username, role: 'admin' }, JWT_SECRET, { expiresIn: '24h' });
    return res.json({ success: true, token });
  }
  return res.status(401).json({ success: false, message: 'Invalid credentials' });
});

// ─── Products Routes ──────────────────────────────────────────────────────────
// GET all products
app.get('/api/products', (req, res) => {
  const db = readDB();
  res.json({ success: true, data: db.products });
});

// GET featured products
app.get('/api/products/featured', (req, res) => {
  const db = readDB();
  const featured = db.products.filter(p => p.isFeatured);
  res.json({ success: true, data: featured });
});

// GET single product
app.get('/api/products/:id', (req, res) => {
  const db = readDB();
  const product = db.products.find(p => p.id === req.params.id);
  if (!product) return res.status(404).json({ success: false, message: 'Product not found' });
  res.json({ success: true, data: product });
});

// POST create product (Protected)
app.post('/api/products', authMiddleware, (req, res) => {
  const { name, price, description, category, imageUrl } = req.body;
  if (!name || price === undefined || !description || !category || !imageUrl) {
    return res.status(400).json({ success: false, message: 'Validation error: Missing required fields' });
  }

  const db = readDB();
  const product = {
    id: uuidv4(),
    createdAt: new Date().toISOString(),
    ...req.body,
  };
  db.products.push(product);
  writeDB(db);
  res.status(201).json({ success: true, data: product });
});

// PUT update product (Protected)
app.put('/api/products/:id', authMiddleware, (req, res) => {
  const { name, price, description, category, imageUrl } = req.body;
  if (!name || price === undefined || !description || !category || !imageUrl) {
    return res.status(400).json({ success: false, message: 'Validation error: Missing required fields' });
  }

  const db = readDB();
  const idx = db.products.findIndex(p => p.id === req.params.id);
  if (idx === -1) return res.status(404).json({ success: false, message: 'Product not found' });
  db.products[idx] = { ...db.products[idx], ...req.body };
  writeDB(db);
  res.json({ success: true, data: db.products[idx] });
});

// DELETE product (Protected)
app.delete('/api/products/:id', authMiddleware, (req, res) => {
  const db = readDB();
  const idx = db.products.findIndex(p => p.id === req.params.id);
  if (idx === -1) return res.status(404).json({ success: false, message: 'Product not found' });
  db.products.splice(idx, 1);
  writeDB(db);
  res.json({ success: true, message: 'Product deleted' });
});

// ─── Testimonials Routes ──────────────────────────────────────────────────────
// GET all testimonials
app.get('/api/testimonials', (req, res) => {
  const db = readDB();
  res.json({ success: true, data: db.testimonials });
});

// GET single testimonial
app.get('/api/testimonials/:id', (req, res) => {
  const db = readDB();
  const item = db.testimonials.find(t => t.id === req.params.id);
  if (!item) return res.status(404).json({ success: false, message: 'Testimonial not found' });
  res.json({ success: true, data: item });
});

// POST create testimonial (Protected)
app.post('/api/testimonials', authMiddleware, (req, res) => {
  const { authorName, role, content, rating } = req.body;
  if (!authorName || !role || !content || rating === undefined) {
    return res.status(400).json({ success: false, message: 'Validation error: Missing required fields' });
  }

  const db = readDB();
  const testimonial = {
    id: uuidv4(),
    createdAt: new Date().toISOString(),
    ...req.body,
  };
  db.testimonials.push(testimonial);
  writeDB(db);
  res.status(201).json({ success: true, data: testimonial });
});

// PUT update testimonial (Protected)
app.put('/api/testimonials/:id', authMiddleware, (req, res) => {
  const { authorName, role, content, rating } = req.body;
  if (!authorName || !role || !content || rating === undefined) {
    return res.status(400).json({ success: false, message: 'Validation error: Missing required fields' });
  }

  const db = readDB();
  const idx = db.testimonials.findIndex(t => t.id === req.params.id);
  if (idx === -1) return res.status(404).json({ success: false, message: 'Testimonial not found' });
  db.testimonials[idx] = { ...db.testimonials[idx], ...req.body };
  writeDB(db);
  res.json({ success: true, data: db.testimonials[idx] });
});

// DELETE testimonial (Protected)
app.delete('/api/testimonials/:id', authMiddleware, (req, res) => {
  const db = readDB();
  const idx = db.testimonials.findIndex(t => t.id === req.params.id);
  if (idx === -1) return res.status(404).json({ success: false, message: 'Testimonial not found' });
  db.testimonials.splice(idx, 1);
  writeDB(db);
  res.json({ success: true, message: 'Testimonial deleted' });
});

// ─── Contacts Routes ──────────────────────────────────────────────────────────
// GET all contacts (Protected - admin only)
app.get('/api/contacts', authMiddleware, (req, res) => {
  const db = readDB();
  res.json({ success: true, data: db.contacts });
});

// POST submit contact form (Public - no auth required)
app.post('/api/contacts', (req, res) => {
  const { name, email, message } = req.body;
  if (!name || !email || !message) {
    return res.status(400).json({ success: false, message: 'Validation error: Missing required fields' });
  }

  const db = readDB();
  const contact = {
    id: uuidv4(),
    createdAt: new Date().toISOString(),
    isRead: false,
    ...req.body,
  };
  db.contacts.push(contact);
  writeDB(db);
  res.status(201).json({ success: true, data: contact });
});

// PUT mark contact as read (Protected)
app.put('/api/contacts/:id/read', authMiddleware, (req, res) => {
  const db = readDB();
  const idx = db.contacts.findIndex(c => c.id === req.params.id);
  if (idx === -1) return res.status(404).json({ success: false, message: 'Contact not found' });
  db.contacts[idx].isRead = true;
  writeDB(db);
  res.json({ success: true, data: db.contacts[idx] });
});

// DELETE contact (Protected)
app.delete('/api/contacts/:id', authMiddleware, (req, res) => {
  const db = readDB();
  const idx = db.contacts.findIndex(c => c.id === req.params.id);
  if (idx === -1) return res.status(404).json({ success: false, message: 'Contact not found' });
  db.contacts.splice(idx, 1);
  writeDB(db);
  res.json({ success: true, message: 'Contact deleted' });
});

// ─── Stats Route ──────────────────────────────────────────────────────────────
// GET stats (Protected)
app.get('/api/stats', authMiddleware, (req, res) => {
  const db = readDB();
  res.json({
    success: true,
    data: {
      totalProducts: db.products.length,
      featuredProducts: db.products.filter(p => p.isFeatured).length,
      totalTestimonials: db.testimonials.length,
      totalContacts: db.contacts.length,
      unreadContacts: db.contacts.filter(c => !c.isRead).length,
    },
  });
});

// ─── Health Check ─────────────────────────────────────────────────────────────
app.get('/api/health', (req, res) => {
  res.json({ success: true, message: 'Pharmacy API running', timestamp: new Date().toISOString() });
});

// ─── Start Server ─────────────────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`\n🚀 Pharmacy API Server running at http://localhost:${PORT}`);
  console.log(`   Health: http://localhost:${PORT}/api/health`);
  console.log(`   Products: http://localhost:${PORT}/api/products`);
  console.log(`   Testimonials: http://localhost:${PORT}/api/testimonials`);
  console.log(`   Contacts: http://localhost:${PORT}/api/contacts\n`);
});
