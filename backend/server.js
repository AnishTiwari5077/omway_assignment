require('dotenv').config();
// Override system DNS to use Google's public DNS (bypasses ISP DNS blocks)
const dns = require('dns');
dns.setServers(['8.8.8.8', '8.8.4.4', '1.1.1.1']);

const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const { v4: uuidv4 } = require('uuid');
const jwt = require('jsonwebtoken');

const Product = require('./models/Product');
const Testimonial = require('./models/Testimonial');
const Contact = require('./models/Contact');

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'super-secret-admin-key-omway';
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/pharmacy';

// ─── Middleware ────────────────────────────────────────────────────────────────
app.use(cors());
app.use(express.json());

// ─── Database Connection (with auto-retry) ───────────────────────────────────
const connectWithRetry = () => {
  mongoose.connect(MONGODB_URI, { serverSelectionTimeoutMS: 10000 })
    .then(() => console.log('✅ Connected to MongoDB'))
    .catch((err) => {
      console.error('❌ MongoDB connection error:', err.message);
      console.log('🔄 Retrying MongoDB connection in 5 seconds...');
      setTimeout(connectWithRetry, 5000);
    });
};
connectWithRetry();

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
app.get('/api/products', async (req, res) => {
  try {
    const products = await Product.find({}, '-_id -__v');
    res.json({ success: true, data: products });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// GET featured products
app.get('/api/products/featured', async (req, res) => {
  try {
    const featured = await Product.find({ isFeatured: true }, '-_id -__v');
    res.json({ success: true, data: featured });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// GET single product
app.get('/api/products/:id', async (req, res) => {
  try {
    const product = await Product.findOne({ id: req.params.id }, '-_id -__v');
    if (!product) return res.status(404).json({ success: false, message: 'Product not found' });
    res.json({ success: true, data: product });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// POST create product (Protected)
app.post('/api/products', authMiddleware, async (req, res) => {
  const { name, price, description, category, imageUrl } = req.body;
  if (!name || price === undefined || !description || !category || !imageUrl) {
    return res.status(400).json({ success: false, message: 'Validation error: Missing required fields' });
  }

  try {
    const product = new Product({
      id: uuidv4(),
      ...req.body,
    });
    await product.save();
    
    // Return without mongoose internal fields
    const productResponse = product.toObject();
    delete productResponse._id;
    delete productResponse.__v;
    
    res.status(201).json({ success: true, data: productResponse });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// PUT update product (Protected)
app.put('/api/products/:id', authMiddleware, async (req, res) => {
  const { name, price, description, category, imageUrl } = req.body;
  if (!name || price === undefined || !description || !category || !imageUrl) {
    return res.status(400).json({ success: false, message: 'Validation error: Missing required fields' });
  }

  try {
    const product = await Product.findOneAndUpdate(
      { id: req.params.id },
      { ...req.body },
      { new: true, projection: '-_id -__v' }
    );
    if (!product) return res.status(404).json({ success: false, message: 'Product not found' });
    res.json({ success: true, data: product });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// DELETE product (Protected)
app.delete('/api/products/:id', authMiddleware, async (req, res) => {
  try {
    const product = await Product.findOneAndDelete({ id: req.params.id });
    if (!product) return res.status(404).json({ success: false, message: 'Product not found' });
    res.json({ success: true, message: 'Product deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// ─── Testimonials Routes ──────────────────────────────────────────────────────
// GET all testimonials
app.get('/api/testimonials', async (req, res) => {
  try {
    const testimonials = await Testimonial.find({}, '-_id -__v');
    res.json({ success: true, data: testimonials });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// GET single testimonial
app.get('/api/testimonials/:id', async (req, res) => {
  try {
    const item = await Testimonial.findOne({ id: req.params.id }, '-_id -__v');
    if (!item) return res.status(404).json({ success: false, message: 'Testimonial not found' });
    res.json({ success: true, data: item });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// POST create testimonial (Protected)
app.post('/api/testimonials', authMiddleware, async (req, res) => {
  const { authorName, role, content, rating } = req.body;
  if (!authorName || !role || !content || rating === undefined) {
    return res.status(400).json({ success: false, message: 'Validation error: Missing required fields' });
  }

  try {
    const testimonial = new Testimonial({
      id: uuidv4(),
      ...req.body,
    });
    await testimonial.save();
    
    const responseData = testimonial.toObject();
    delete responseData._id;
    delete responseData.__v;
    
    res.status(201).json({ success: true, data: responseData });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// PUT update testimonial (Protected)
app.put('/api/testimonials/:id', authMiddleware, async (req, res) => {
  const { authorName, role, content, rating } = req.body;
  if (!authorName || !role || !content || rating === undefined) {
    return res.status(400).json({ success: false, message: 'Validation error: Missing required fields' });
  }

  try {
    const testimonial = await Testimonial.findOneAndUpdate(
      { id: req.params.id },
      { ...req.body },
      { new: true, projection: '-_id -__v' }
    );
    if (!testimonial) return res.status(404).json({ success: false, message: 'Testimonial not found' });
    res.json({ success: true, data: testimonial });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// DELETE testimonial (Protected)
app.delete('/api/testimonials/:id', authMiddleware, async (req, res) => {
  try {
    const testimonial = await Testimonial.findOneAndDelete({ id: req.params.id });
    if (!testimonial) return res.status(404).json({ success: false, message: 'Testimonial not found' });
    res.json({ success: true, message: 'Testimonial deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// ─── Contacts Routes ──────────────────────────────────────────────────────────
// GET all contacts (Protected - admin only)
app.get('/api/contacts', authMiddleware, async (req, res) => {
  try {
    const contacts = await Contact.find({}, '-_id -__v');
    res.json({ success: true, data: contacts });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// POST submit contact form (Public - no auth required)
app.post('/api/contacts', async (req, res) => {
  const { name, email, message } = req.body;
  if (!name || !email || !message) {
    return res.status(400).json({ success: false, message: 'Validation error: Missing required fields' });
  }

  try {
    const contact = new Contact({
      id: uuidv4(),
      ...req.body,
    });
    await contact.save();
    
    const responseData = contact.toObject();
    delete responseData._id;
    delete responseData.__v;
    
    res.status(201).json({ success: true, data: responseData });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// PUT mark contact as read (Protected)
app.put('/api/contacts/:id/read', authMiddleware, async (req, res) => {
  try {
    const contact = await Contact.findOneAndUpdate(
      { id: req.params.id },
      { isRead: true },
      { new: true, projection: '-_id -__v' }
    );
    if (!contact) return res.status(404).json({ success: false, message: 'Contact not found' });
    res.json({ success: true, data: contact });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// DELETE contact (Protected)
app.delete('/api/contacts/:id', authMiddleware, async (req, res) => {
  try {
    const contact = await Contact.findOneAndDelete({ id: req.params.id });
    if (!contact) return res.status(404).json({ success: false, message: 'Contact not found' });
    res.json({ success: true, message: 'Contact deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// ─── Stats Route ──────────────────────────────────────────────────────────────
// GET stats (Protected)
app.get('/api/stats', authMiddleware, async (req, res) => {
  try {
    const totalProducts = await Product.countDocuments();
    const featuredProducts = await Product.countDocuments({ isFeatured: true });
    const totalTestimonials = await Testimonial.countDocuments();
    const totalContacts = await Contact.countDocuments();
    const unreadContacts = await Contact.countDocuments({ isRead: false });

    res.json({
      success: true,
      data: {
        totalProducts,
        featuredProducts,
        totalTestimonials,
        totalContacts,
        unreadContacts,
      },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// ─── Health Check ─────────────────────────────────────────────────────────────
app.get('/api/health', (req, res) => {
  const dbState = mongoose.connection.readyState === 1 ? 'connected' : 'disconnected';
  res.json({ 
    success: true, 
    message: 'Pharmacy API running', 
    database: dbState,
    timestamp: new Date().toISOString() 
  });
});

// ─── Start Server ─────────────────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`\n🚀 Pharmacy API Server running at http://localhost:${PORT}`);
  console.log(`   Health: http://localhost:${PORT}/api/health`);
  console.log(`   Products: http://localhost:${PORT}/api/products`);
  console.log(`   Testimonials: http://localhost:${PORT}/api/testimonials`);
  console.log(`   Contacts: http://localhost:${PORT}/api/contacts\n`);
});
