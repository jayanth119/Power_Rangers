const fetch = require('node-fetch'); // if using Node < 18
const BloodBank = require('../models/BloodBank');
const BloodGroup = require('../models/BloodGroup');
const BloodComponents = require('../models/BloodComponents');

exports.storeBloodBanks = async (req, res) => {
  const url = "https://api.data.gov.in/resource/fced6df9-a360-4e08-8ca0-f283fc74ce15?api-key=579b464db66ec23bdd000001603eb0cc38324dd768735197a75609f5&format=json&limit=2823";
  
  try {
    const response = await fetch(url);
    const data = await response.json();
    const records = data.records;

    // Transform each record to match our Mongoose schema with random blood group and components
    const transformedRecords = records.map(record => ({
      sr_no: record.sr_no,
      blood_bank_name: record._blood_bank_name,
      state: record._state,
      district: record._district,
      city: record._city,
      address: record._address,
      pincode: record.pincode,
      contact_no: record._contact_no,
      mobile: record._mobile,
      helpline: record._helpline,
      fax: record._fax,
      email: record._email,
      website: record._website,
      nodal_officer: record._nodal_officer_,
      contact_nodal_officer: record._contact_nodal_officer,
      mobile_nodal_officer: record._mobile_nodal_officer,
      email_nodal_officer: record._email_nodal_officer,
      qualification_nodal_officer: record._qualification_nodal_officer,
      category: record._category,
      blood_component_available: record._blood_component_available,
      apheresis: record._apheresis,
      service_time: record._service_time,
      license: record._license__,
      date_license_obtained: parseDate(record._date_license_obtained),
      date_of_renewal: parseDate(record._date_of_renewal),
      latitude: record._latitude,
      longitude: record._longitude,
      bloodgroup: generateRandomBloodGroup(),
      blood_component: generateRandomBloodComponents()
    }));

    // Insert the transformed records into the database
    BloodBank.insertMany(transformedRecords, (err, result) => {
      if (err) {
        console.error('Insert error:', err);
        return res.status(500).json({ message: 'Error inserting records into database' });
      }
      console.log('Insert success:', result);
      res.status(200).json({ message: 'Records inserted successfully', count: result.length });
    });
  } catch (error) {
    console.error('Fetch error:', error);
    res.status(500).json({ message: 'Error fetching data from URL' });
  }
};

// Helper function to convert date strings (e.g. "14.6.1996") into a Date object.
function parseDate(dateString) {
  if (!dateString) return null;
  const parts = dateString.split('.');
  if (parts.length !== 3) return null;
  
  const [day, month, year] = parts;
  const date = new Date(year, month - 1, day);
  
  return isNaN(date.getTime()) ? null : date;
}

// Generate random blood group data
function generateRandomBloodGroup() {
  const A = getRandomInt(10, 100);
  const B = getRandomInt(10, 100);
  const AB = getRandomInt(10, 100);
  const O = getRandomInt(10, 100);
  return {
    A,
    B,
    AB,
    O,
    total: A + B + AB + O
  };
}

// Generate random blood component data
function generateRandomBloodComponents() {
  const wholeBlood = getRandomInt(5, 50);
  const singleDonorPlatelets = getRandomInt(5, 50);
  const singleDonorPlasma = getRandomInt(5, 50);
  const sagmPackedRbc = getRandomInt(5, 50);
  const randomDonorPlatelets = getRandomInt(5, 50);
  const plaletRichPlasma = getRandomInt(5, 50);
  const platetConcentrate = getRandomInt(5, 50);
  const plasma = getRandomInt(5, 50);
  const packedRbc = getRandomInt(5, 50);
  const cryoprecipitate = getRandomInt(5, 50);
  const leukoreducedRbc = getRandomInt(5, 50);
  const freshFrozenPlasma = getRandomInt(5, 50);
  const irediatedRbc = getRandomInt(5, 50);
  const cryopoorPlasma = getRandomInt(5, 50);

  return {
    wholeBlood,
    singleDonorPlatelets,
    singleDonorPlasma,
    sagmPackedRbc,
    randomDonorPlatelets,
    plaletRichPlasma,
    platetConcentrate,
    plasma,
    packedRbc,
    cryoprecipitate,
    leukoreducedRbc,
    freshFrozenPlasma,
    irediatedRbc,
    cryopoorPlasma,
    total: wholeBlood + singleDonorPlatelets + singleDonorPlasma + sagmPackedRbc +
           randomDonorPlatelets + plaletRichPlasma + platetConcentrate + plasma +
           packedRbc + cryoprecipitate + leukoreducedRbc + freshFrozenPlasma +
           irediatedRbc + cryopoorPlasma
  };
}

// Helper function to generate a random integer between min and max
function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}
