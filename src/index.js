const http = require("http");
const port = process.env.PORT || 3000;
http
  .createServer((_, res) => {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ status: "ok", service: "poc-microservice-node" }));
  })
  .listen(port, () => console.log(`listening on ${port}`));
