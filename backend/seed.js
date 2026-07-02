require('dotenv').config();
// Override system DNS to use Google's public DNS (bypasses ISP DNS blocks)
const dns = require('dns');
dns.setServers(['8.8.8.8', '8.8.4.4', '1.1.1.1']);

const mongoose = require('mongoose');
const fs = require('fs');
const path = require('path');

const Product = require('./models/Product');
const Testimonial = require('./models/Testimonial');
const Contact = require('./models/Contact');

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/pharmacy';
const DB_PATH = path.join(__dirname, 'data', 'db.json');

async function seedData() {
  try {
    console.log('Connecting to MongoDB...');
    await mongoose.connect(MONGODB_URI);
    console.log('✅ Connected.');

    console.log('Reading db.json...');
    const raw = fs.readFileSync(DB_PATH, 'utf-8');
    const db = JSON.parse(raw);

    console.log('Clearing old collections...');
    await Product.deleteMany({});
    await Testimonial.deleteMany({});
    await Contact.deleteMany({});

    console.log('Seeding Products...');
    if (db.products && db.products.length > 0) {
      await Product.insertMany(db.products);
      console.log(`✅ Seeded ${db.products.length} products.`);
    }

    console.log('Seeding Testimonials...');
    if (db.testimonials && db.testimonials.length > 0) {
      await Testimonial.insertMany(db.testimonials);
      console.log(`✅ Seeded ${db.testimonials.length} testimonials.`);
    }

    console.log('Seeding Contacts...');
    if (db.contacts && db.contacts.length > 0) {
      await Contact.insertMany(db.contacts);
      console.log(`✅ Seeded ${db.contacts.length} contacts.`);
    }

    console.log('🎉 Database seeding completed successfully!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error seeding database:', error);
    process.exit(1);
  }
}

seedData();
