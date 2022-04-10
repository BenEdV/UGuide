const {MongoClient} = require('mongodb');

const url = process.env.MONGO_URL;

let max_tries = 30;
let connection_established = false;

function sleep(seconds) {
  return new Promise(resolve => {
    setTimeout(() => resolve(seconds), seconds * 1000);
  });
}

async function connect() {
  for (let tries = 0; tries < max_tries; tries++) {
    try {
      await MongoClient.connect(url);
      connection_established = true;
      break;
    } catch(e) {
      console.log("Waiting for MongoDB...")
      await sleep(1);
    }
  }

  if (connection_established) {
    console.log("Connection with MongoDB established")
    process.exit(0);
  } else {
    console.log("Could not establish connection to MongoDB")
    process.exit(1);
  }
}

connect();
