const mongoose = require('mongoose');

const contactSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true }, // Keeping existing string ID
  name: { type: String, required: true },
  email: { type: String, required: true },
  phone: { type: String },
  message: { type: String, required: true },
  isRead: { type: Boolean, default: false },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Contact', contactSchema);
