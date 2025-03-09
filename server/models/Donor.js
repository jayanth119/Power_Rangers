const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const Donor = new Schema({
    name: { type: String, required: true },
    age: { type: Number, required: true },
    bloodType: { type: String, required: true },
    location: { type: String, required: true },
    locationCoordinates: {
        type: {
            type: String,
            enum: ['Point']
        },
        coordinates: {
            type: [Number],
            index: '2dsphere'
        }
    },
    contact: { type: String, required: true },
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Donor', Donor);