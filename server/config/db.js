const mongoose = require('mongoose');

const connectDB = async () => {
  const conn = await mongoose.connect("mongodb+srv://Jayanth:HAKUNAmatata123@jayanth.7ackfrz.mongodb.net/?retryWrites=true&w=majority&appName=Jayanth", {
  });

  console.log(`MongoDB Connected -> ${conn.connection.host}`.cyan.underline);
};

module.exports = connectDB;
