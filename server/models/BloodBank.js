const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const BloodGroup = require('./BloodGroup');
const BloodComponents = require('./BloodComponents');
const bloodBankSchema = new Schema({
  sr_no: { type: Number, required: true, unique: true },
  blood_bank_name: { type: String, required: true },
  state: { type: String },
  district: { type: String },
  city: { type: String },
  address: { type: String },
  pincode: { type: String },
  contact_no: { type: String },
  mobile: { type: String },
  helpline: { type: String },
  fax: { type: String },
  email: { type: String },
  website: { type: String },
  nodal_officer: { type: String },
  contact_nodal_officer: { type: String },
  mobile_nodal_officer: { type: String },
  email_nodal_officer: { type: String },
  qualification_nodal_officer: { type: String },
  category: { type: String },
  blood_component_available: { type: String },
  apheresis: { type: String },
  service_time: { type: String },
  license: { type: String },
  bloodgroup : { type: BloodGroup.schema },
  blood_component : { type: BloodComponents.schema },
  date_license_obtained: { type: Date },
  date_of_renewal: { type: Date },
  latitude: { type: Number },
  longitude: { type: Number },
});

// Export the model
module.exports = mongoose.model("BloodBank", bloodBankSchema);
