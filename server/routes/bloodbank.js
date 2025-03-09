const express = require('express');
const router = express.Router();
const bloodBankController = require('../controllers/bloodbank');
const { protect } = require('../middlewares/auth');

router.get('/adddata', bloodBankController.storeBloodBanks);



module.exports = router;
