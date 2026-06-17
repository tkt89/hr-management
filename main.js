const express = require("express");
const app = express();
const port = 4000;

const mysql = require("mysql2");

const dbConnection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "Password8989++",
  database: "employees",
});

app.use(express.static("public"));
app.set("view engine", "ejs");

app.use((req, res, next) => {
  res.locals.path = req.path;
  next();
});

app.get("/", (req, res) => {
  dbConnection.query("SELECT * FROM employees", (err, employees) => {
    if (err) {
      console.error("Error fetching employees:", err);
      return res.status(500).send("Error fetching employees");
    }
    res.render("index.ejs", { employees });
  });
});

app.get("/employees", (req, res) => {
  dbConnection.query("SELECT * FROM employees", (err, employees) => {
    if (err) {
      console.error("Error fetching employees:", err);
      return res.status(500).send("Error fetching employees");
    }
    res.render("employees.ejs", { employees });
  });
});

app.get("/payroll", (req, res) => {
  dbConnection.query("SELECT * FROM salaries", (err, salaries) => {
    if (err) {
      console.error("Error fetching payroll:", err);
      return res.status(500).send("Error fetching payroll");
    }

    const totalSalary = salaries.reduce((sum, s) => sum + s.current_salary, 0);

    res.render("payroll", { salaries, totalSalary });
  });
});

app.get("/recruitment", (req, res) => {
  dbConnection.query("SELECT * FROM recruits", (err, recruits) => {
    if (err) {
      console.error("Error fetching recruitment candidates:", err);
      return res.status(500).send("Error fetching recruitment candidates");
    }
    res.render("recruitment.ejs", { recruits });
  });
});

app.get("/reports", (req, res) => {
  res.render("reports.ejs");
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
