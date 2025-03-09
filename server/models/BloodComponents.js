const mangoose = require('mongoose');
const Schema = mangoose.Schema;

const BloodComponents = new Schema({
    wholeBlood: { type: Number,  required: true , default : 0 },
    singleDonorPlatelets: { type: Number,  required: true , default : 0 },
    singleDonorPlasma: { type: Number,  required: true , default : 0 },
    sagmPackedRbc: { type: Number,  required: true , default : 0 },
    randomDonorPlatelets: { type: Number,  required: true , default : 0 },
    plaletRichPlasma: { type: Number,  required: true , default : 0 },
    platetConcentrate: { type: Number,  required: true , default : 0 },
    plasma : { type: Number,  required: true , default : 0 },
    packedRbc : { type: Number,  required: true , default : 0 },
    cryoprecipitate : { type: Number,  required: true , default : 0 },
   leukoreducedRbc : { type: Number,  required: true , default : 0 },
   freshFrozenPlasma : { type: Number,  required: true , default : 0 },
    irediatedRbc : { type: Number,  required: true , default : 0 },
    cryopoorPlasma : { type: Number,  required: true , default : 0 },

    total : { type: Number,  required: true , default : 0 }

});

module.exports = mangoose.model('BloodComponents', BloodComponents);

