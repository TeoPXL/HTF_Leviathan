// healthcheck.js
// noinspection DuplicatedCode

const http = require('http');
const options = {
  host: 'localhost',
  port: 81,
  path: '/health', // Adjust to your health endpoint
  timeout: 2000
};

const request = http.get(options, (res) => {
  console.log(`STATUS: ${res.statusCode}`);
  process.exit(res.statusCode === 200 ? 0 : 1);
});

request.on('error', (err) => {
  console.error('ERROR', err);
  process.exit(1);
});

request.end();
