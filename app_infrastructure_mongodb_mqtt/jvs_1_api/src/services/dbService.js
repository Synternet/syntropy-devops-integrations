import logger from '../utils/logger';
const mongoose = require('mongoose');

// Setup mongodb
export function setupMongo(mongoConnection) {
  
  mongoose.connect(mongoConnection, { useNewUrlParser: true });
  mongoose.Promise = global.Promise;
  const db = mongoose.connection;
  db.on('error', () => console.error.bind(console, 'MongoDB connection error!:'));

  const { Schema } = mongoose;

  const fibSchema = new Schema({
    num:  Number,
    res: Number
  });
  const fibDbModel = mongoose.model('FibModel', fibSchema);
}

// Add calculated number to mongodb
export async function addResult(num, res) {
  const fibModel = mongoose.model('FibModel');
  const fibRes = new fibModel({num, res});
  await fibRes.save();
  logger.info(`Fibonacci of ${num}(${res}) saved to db`, );
}

// Fetch precalculated number from mongodb
export async function isFibSaved(num) {
  const fibModel = mongoose.model('FibModel');
  const result = await fibModel.findOne({ num }).exec();
  return result ? result.res : null;
}


