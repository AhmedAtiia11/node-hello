const http = require('http');
const port = process.env.PORT || 3000;
// add this for newrelic
require('newrelic');

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  const msg = 'Hello Node! testing 1234 \n'
  res.end(msg);
});

server.listen(port, () => {
  console.log(`Server running on http://localhost:${port}/`);
});
