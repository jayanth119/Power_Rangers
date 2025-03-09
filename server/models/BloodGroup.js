const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const bloodGroupSchema = new Schema({
    A : { type: Number, required: true },
    B : { type: Number, required: true },
    AB : { type: Number, required: true },
    O : { type: Number, required: true },
    total : { type: Number, required: true }
});

module.exports = mongoose.model("BloodGroup", bloodGroupSchema);
