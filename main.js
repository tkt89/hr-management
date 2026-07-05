const express = require("express");
const app = express();
const port = 4000;

const bcrypt = require("bcrypt");
const saltRounds = 12;

const session = require("express-session");

const mysql = require("mysql2");

const dbConnection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "Password8989++",
  database: "employees",
});

app.use(
  session({
    secret: "3hdhjbyg738298u42bchuhcf",
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false },
  }),
);

app.use(express.static("public"));
app.use(express.urlencoded({ extended: true }));
app.set("view engine", "ejs");

app.use((req, res, next) => {
  res.locals.path = req.path;
  res.locals.user = req.session.user || null;
  next();
});

app.get("/login", (req, res) => {
  res.render("login.ejs");
});

app.post("/login", (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.render("login.ejs", {
      error: "Email and password are required",
    });
  }

  const loginSql = "SELECT * FROM login WHERE email = ? LIMIT 1";

  dbConnection.query(loginSql, [email], function (err, results) {
    if (err) {
      console.error("Database error:", err);
      return res.render("login.ejs", { error: "Server error" });
    }

    if (results.length === 0) {
      return res.render("login.ejs", {
        error: "Either your email or password is incorrect",
      });
    }

    const userRow = results[0];

    bcrypt.compare(password, userRow.password, (err, passwordsMatch) => {
      if (err) throw err;

      if (passwordsMatch) {
        req.session.user = {
          id: userRow.name,
          email: userRow.email,
        };

        res.redirect("/");
      } else {
        res.render("login.ejs", {
          error: "Either your email or password is incorrect",
        });
      }
    });
  });
});

app.get("/signup", (req, res) => {
  res.render("signup.ejs");
});

app.post("/signup", (req, res) => {
  const { name, newEmail, rawPassword } = req.body;

  if (!name || !newEmail || !rawPassword) {
    return res.render("signup", { error: "All fields are required" });
  }

  bcrypt.hash(rawPassword, saltRounds, (err, hashedPassword) => {
    if (err) throw err;

    const checkSql = "SELECT COUNT(*) AS count FROM login WHERE email = ?";

    dbConnection.query(checkSql, [newEmail], (err, result) => {
      if (err) throw err;

      const emailExists = result[0].count > 0;

      if (emailExists) {
        return res.render("signup", {
          error: "Another account has already been signed in with this email",
        });
      }

      const insertSql =
        "INSERT INTO login (name, email, password) VALUES (?, ?, ?)";
      const values = [name, newEmail, hashedPassword];

      dbConnection.query(insertSql, values, (err, results) => {
        if (err) {
          console.error("Database error:", err);
          return res.render("signup", { error: "Something went wrong" });
        }
        res.redirect("/login");
      });
    });
  });
});

app.get("/", (req, res) => {
  if (!res.locals.user) {
    return res.redirect("/login");
  }

  dbConnection.query("SELECT * FROM employees", (err, employees) => {
    if (err) {
      console.error("Error fetching employees:", err);
      return res.status(500).send("Error fetching employees");
    }
    res.render("index.ejs", { employees, user: res.locals.user });
  });
});

app.get("/employees", (req, res) => {
  const user = req.session.user;

  if (!user) {
    return res.redirect("/login");
  }

  dbConnection.query("SELECT * FROM employees", (err, employees) => {
    if (err) {
      console.error("Error fetching employees:", err);
      return res.status(500).send("Error fetching employees");
    }
    res.render("employees.ejs", { employees, user });
  });
});

app.get("/employees/Add-Employee", (req, res) => {
  if (!res.locals.user) {
    return res.redirect("/login");
  }

  res.render("addemployee.ejs");
});

app.post("/employees/Add-Employee", (req, res) => {
  const {
    employee_name,
    date_of_birth,
    gender,
    phone_number,
    email_address,
    home_address,
    department_id,
    date_joined,
    role,
    location,
  } = req.body;

  const sql =
    "INSERT INTO employees (employee_name, date_of_birth, gender, phone_number, email_address, home_address, department_id, date_joined, role, location) VALUES(?,?,?,?,?,?,?,?,?,?)";

  const values = [
    employee_name,
    date_of_birth,
    gender,
    phone_number,
    email_address,
    home_address,
    department_id,
    date_joined,
    role,
    location,
  ];

  dbConnection.query(sql, values, (err, results) => {
    if (err) {
      return res.render("addemployee", {
        error: "An Error Occured While adding Employee",
      });
    }
    res.redirect("/employees");
  });
});

app.get("/payroll", (req, res) => {
  if (!res.locals.user) {
    return res.redirect("/login");
  }

  const sql = `
    SELECT 
      s.salary_id,
      s.employee_id,
      e.employee_name,
      s.current_salary,
      s.previous_salary,
      s.commission,
      (s.current_salary + IFNULL(s.commission, 0)) AS total_compensation,
      s.advance,
      s.reason_for_advance,
      s.paid
    FROM salaries s
    JOIN employees e ON s.employee_id = e.employee_id
  `;

  dbConnection.query(sql, (err, salaries) => {
    if (err) {
      console.error("Error fetching payroll:", err);
      return res.status(500).send("Error fetching payroll");
    }

    const totalSalary = salaries.reduce(
      (sum, s) => sum + s.current_salary + (s.commission || 0),
      0,
    );

    const totalSalaries = salaries
      .reduce((sum, s) => sum + totalSalary, 0)
      .toLocaleString();

    res.render("payroll", { salaries, totalSalaries, totalSalary });
  });
});

app.get("/recruitment", (req, res) => {
  if (!res.locals.user) {
    return res.redirect("/login");
  }

  dbConnection.query("SELECT * FROM recruits", (err, recruits) => {
    if (err) {
      console.error("Error fetching recruitment candidates:", err);
      return res.status(500).send("Error fetching recruitment candidates");
    }
    res.render("recruitment.ejs", { recruits, user: req.session.user });
  });
});

app.get("/reports", (req, res) => {
  if (!res.locals.user) {
    return res.redirect("/login");
  }

  res.render("reports.ejs", { user: req.session.user });
});

app.get("/logout", (req, res) => {
  req.session.destroy(() => {
    res.clearCookie("connect.sid");
    res.redirect("/login");
  });
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
