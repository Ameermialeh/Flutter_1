const express = require("express");
const router = express.Router();
const path = require("path");
var db = require("../connections/db.js");
const bcrypt = require("bcrypt");
const nodemailer = require("nodemailer");

router.route("/profile").get((req, res) => {
  const { email } = req.query;
  if (!email) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }
  var sql = "SELECT * FROM user WHERE email=?";

  db.query(sql, [email], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.send(JSON.stringify({ success: true, data: data }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/updateAdmin").post((req, res) => {
  const { id, email, name, phone } = req.body;

  if (!id || !email || !name || !phone) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  const sqlQuery = "UPDATE user SET name = ?, phone = ?, email =? WHERE id = ?";

  db.query(sqlQuery, [name, phone, email, id], (err, data, fields) => {
    if (err) {
      console.error("Database error:", err);
      return res
        .status(500)
        .json({ success: false, message: "Internal server error." });
    } else {
      return res
        .status(200)
        .json({ success: true, message: "Updated Successfully" });
    }
  });
});
//
router.route("/addAdmin").post(async (req, res) => {
  const { email, name, phone, date } = req.body;
  var password = req.body.password.trim();

  if (!email || !name || !phone || !date || !password) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  const salt = await bcrypt.genSalt(10);
  let hashedPassword = await bcrypt.hash(password, salt);
  password = hashedPassword;

  var sqlQuery =
    "INSERT INTO user(name,email,phone,date,city,password,user) VALUES (?,?,?,?,?,?,?)";

  db.query(
    sqlQuery,
    [name, email, phone, date, "", password, "admin"],
    (err, data, fields) => {
      if (err) {
        return res.status(500).json({ success: false, message: err });
      } else {
        res.send(
          JSON.stringify({ success: true, message: "Added admin successfully" })
        );
      }
    }
  );
});
//
router.route("/getFeedBack").get((req, res) => {
  const { rate } = req.query;
  if (!rate) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }
  let doubleValue1 = Number(rate);
  let doubleValue2;
  if (rate != 5) {
    doubleValue2 = Number(rate) + 0.5;
  }

  var sql = "SELECT * FROM feedback WHERE rate = ? OR rate = ?";

  db.query(sql, [doubleValue1, doubleValue2], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.send(JSON.stringify({ success: true, data: data }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getAvgFeedback").get((req, res) => {
  var sql = "SELECT rate FROM feedback";

  db.query(sql, function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.send(JSON.stringify({ success: true, data: data }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getUserData").get((req, res) => {
  const { userID } = req.query;
  if (!userID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM user WHERE id = ?";

  db.query(sql, [userID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, data: data }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getServiceData").get((req, res) => {
  const { userID } = req.query;
  if (!userID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM business WHERE id = ?";

  db.query(sql, [userID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, data: data }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/sendMessage").post(async (req, res) => {
  const message = req.body.message.trim();
  const email = req.body.email.trim();
  console.log(email);
  console.log(message);

  if (email && message) {
    try {
      const checkEmailQuery = `SELECT * FROM user WHERE email='${email}'`;
      db.query(checkEmailQuery, (err, result) => {
        if (err) {
          return res
            .status(500)
            .json({ success: false, message: "Database error ." });
        }
        if (!result || result.length === 0) {
          return res
            .status(404)
            .json({ success: false, message: "Email not found." });
        }
        const transporter = nodemailer.createTransport({
          service: "gmail",
          auth: {
            user: process.env.EMAIL,
            pass: process.env.PASSWORD,
          },
          tls: {
            rejectUnauthorized: false,
          },
        });
        const mailOptions = {
          from: process.env.EMAIL,
          to: email,
          subject: "Response for your report!",
          text: message,
        };
        transporter.sendMail(mailOptions, (mailErr) => {
          if (mailErr) {
            console.error("Error in sending email:", mailErr);
            return res
              .status(500)
              .json({ success: false, message: "Error in sending email." });
          }

          console.log("The email has been sent");
          return res
            .status(200)
            .json({ success: true, message: "Response sent" });
        });
      });
    } catch (err) {
      console.error("Error:", err);
      res.status(500).json({
        status: "ERROR",
        success: false,
        message: "Internal server error",
      });
    }
  } else {
    console.error("Invalid request:", email, message);
    res
      .status(400)
      .json({ status: "ERROR", success: false, message: "Invalid request" });
  }
});
//
router.route("/getReports").get((req, res) => {
  var sql = "SELECT * FROM reports";

  db.query(sql, function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, data: data }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getRequests").get(async (req, res) => {
  let sqlQuery = "SELECT * FROM business WHERE active=0";
  db.query(sqlQuery, (error, result) => {
    if (!error) {
      let users_emails = [];
      for (let i = 0; i < result.length; i++) {
        users_emails.push(result[i].email);
      }
      let sqlQuery2 =
        "SELECT * FROM user WHERE email IN ('" +
        users_emails.join("', '") +
        "')";
      db.query(sqlQuery2, (error, result2) => {
        if (!error) {
          let finalResult = {
            data: [], // Array to store combined data
          };

          for (let i = 0; i < result.length; i++) {
            let businessData = result[i];
            let correspondingUser = result2.find(
              (user) => user.email === businessData.email
            );
            let combinedData = {
              business: businessData,
              user: correspondingUser,
            };
            finalResult.data.push(combinedData);
          }

          res.status(200).json({ success: true, data: finalResult });
        } else {
          console.log(error);
          res.sendStatus(500);
        }
      });
    } else {
      console.log(error);
      res
        .status(500)
        .json({ status: "ERROR", success: false, message: "DB Error!" });
    }
  });
});
//
router.route("/acceptRequest").post(async (req, res) => {
  const { requestId } = req.body;
  let sqlQuery = "SELECT * FROM business WHERE id= ?";

  db.query(sqlQuery, [requestId], (error, result) => {
    if (error) {
      return res
        .status(400)
        .json({ success: false, message: "No such Request Found!" });
    } else {
      let sqlQuery2 = "UPDATE business SET active = 1 WHERE id = ?";
      db.query(sqlQuery2, [requestId], (err) => {
        if (err) {
          return res
            .status(400)
            .json({ success: false, message: "No such Request Found!" });
        } else {
          let sql =
            "UPDATE user SET numBusiness = numBusiness + 1 WHERE email = ?";

          db.query(sql, [result[0]["email"]], (error, result) => {
            if (error) {
              return res.status(400).json({
                success: false,
                message: "Error of update user number of Business",
              });
            } else {
              return res
                .status(200)
                .json({ success: true, message: "Update successful" });
            }
          });
        }
      });
    }
  });
});
//
router.route("/declineRequest").post(async (req, res) => {
  const { requestId } = req.body;
  let sqlQuery3 = "DELETE FROM business WHERE id= ?";
  db.query(sqlQuery3, [requestId], (err, result) => {
    if (err) throw err;
    res.status(200).json({
      success: true,
      message: "Declined Successfully and Business is removed from the system.",
    });
  });
});
//
router.route("/getNumUser").get((req, res) => {
  var sql = "SELECT COUNT(*) as count FROM user";

  db.query(sql, function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res
          .status(200)
          .send(JSON.stringify({ success: true, data: data[0]["count"] }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getNumServices").get((req, res) => {
  var sql = "SELECT COUNT(*) as count FROM business";

  db.query(sql, function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res
          .status(200)
          .send(JSON.stringify({ success: true, data: data[0]["count"] }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getPercentageOfType").get((req, res) => {
  var sql = "SELECT * FROM business";
  var list = [];
  var Singer = 0;
  var DJ = 0;
  var Studio = 0;
  var Decorating = 0;
  var Chair_rental = 0;
  var Stage_rental = 0;
  var Restaurant = 0;
  var Organizer = 0;

  db.query(sql, function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        for (var i = 0; i < data.length; i++) {
          if (data[i]["serviceType"] == "Singer") {
            Singer++;
          } else if (data[i]["serviceType"] == "DJ") {
            DJ++;
          } else if (data[i]["serviceType"] == "Studio") {
            Studio++;
          } else if (data[i]["serviceType"] == "Decorating") {
            Decorating++;
          } else if (data[i]["serviceType"] == "Chair rental") {
            Chair_rental++;
          } else if (data[i]["serviceType"] == "Stage rental") {
            Stage_rental++;
          } else if (data[i]["serviceType"] == "Restaurant") {
            Restaurant++;
          } else {
            Organizer++;
          }
        }
        list.push({
          Singer: Singer,
          DJ: DJ,
          Studio: Studio,
          Decorating: Decorating,
          Chair_rental: Chair_rental,
          Stage_rental: Stage_rental,
          Restaurant: Restaurant,
          Organizer: Organizer,
        });
        res.status(200).send(JSON.stringify({ success: true, data: list }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getSuspendedAccount").get(async (req, res) => {
  let sqlQuery = "SELECT * FROM business WHERE Susbend_Account = 1";
  db.query(sqlQuery, (error, result) => {
    if (error) {
      console.log("Internal Server error !");
    } else {
      res.status(200).json({ success: true, data: result });
    }
  });
});
//
router.route("/changeStatus").post(async (req, res) => {
  var id = req.body.id;
  let sqlQuery =
    "UPDATE business SET Susbend_Account = 0, reports_Counter = 0 ,active = 1 WHERE id = ?;";
  db.query(sqlQuery, [id], (error, result) => {
    if (error) {
      res
        .status(400)
        .json({ success: false, message: "Error in updating business data" });
    } else {
      sqlQuery1 = ` DELETE FROM reports WHERE serviceID= ?`;
      db.query(sqlQuery1, [id], (err, result1) => {
        if (err) {
          res
            .status(400)
            .json({ success: false, message: "Error in deleting data" });
        } else {
          res
            .status(200)
            .json({ success: true, message: "Data deleted Success" });
        }
      });
    }
  });
});
//

module.exports = router;
