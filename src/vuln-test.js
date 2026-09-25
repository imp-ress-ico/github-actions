const mysql = require("mysql");
const http = require("node:http");

const db = mysql.createConnection({ host: "localhost", user: "root", database: "test" });

http.createServer((req, res) => {
  const id = new URL(req.url, "http://localhost").searchParams.get("id");
  // VULNERABLE: user input concatenated into SQL → injection
  db.query("SELECT * FROM users WHERE id = " + id, (err, rows) => {
    res.end(JSON.stringify(rows || []));
  });
}).listen(4000);
