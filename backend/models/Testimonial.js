const mongoose = require('mongoose');

const testimonialSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true }, // Keeping existing string ID
  authorName: { type: String, required: true },
  role: { type: String, required: true },
  content: { type: String, required: true },
  rating: { type: Number, required: true },
  avatarUrl: { type: String },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Testimonial', testimonialSchema);
