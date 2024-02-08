const constant = require("dotenv").config({ path: "indexApi/constant.env" });
const express = require("express");
const fs = require("fs");
const path = require("path");
const router = express.Router();
const multer = require("multer");
const bcrypt = require("bcrypt");
const nodemailer = require("nodemailer");
var db = require("../connections/db.js");
const cron = require("node-cron");
const moment = require("moment");
//
const uploadsFolder = path.join(__dirname, "uploads");
if (!fs.existsSync(uploadsFolder)) {
  fs.mkdirSync(uploadsFolder);
}
//
const postsFolder = path.join(__dirname, "PostsMainImg");
if (!fs.existsSync(postsFolder)) {
  fs.mkdirSync(postsFolder);
}
//
const subImgFolder = path.join(__dirname, "subImgFolder");
if (!fs.existsSync(subImgFolder)) {
  fs.mkdirSync(subImgFolder);
}
//
const uploadsAudio = path.join(__dirname, "Audios");
const songImage = path.join(__dirname, "songImage");

if (!fs.existsSync(uploadsAudio)) {
  fs.mkdirSync(uploadsAudio);
}

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, uploadsAudio);
  },
  filename: function (req, file, cb) {
    const songName = req.body.songName || "Untitled";
    const userID = req.body.userID || "0";
    const fileExtension = file.originalname.split(".").pop();
    const fileName = `${userID}_${songName}.${fileExtension}`;
    cb(null, fileName);
  },
});

const upload = multer({
  storage: storage,
});
if (!fs.existsSync(songImage)) {
  fs.mkdirSync(songImage);
}
//
cron.schedule("* * * * *", () => {
  const currentDate = new Date().toISOString().split("T")[0];

  const query = `SELECT * FROM reservation WHERE status = 'waiting' AND STR_TO_DATE(date, '%Y-%m-%d') < '${currentDate}' `;

  db.query(query, (err, results) => {
    if (err) {
      console.error("Error during query:", err);
      return;
    }

    // Delete rows where yourVariable is equal to zero
    results.forEach(async (row) => {
      const deleteQuery = `UPDATE reservation SET status = 'Canceled' WHERE id = ${row.id}`;
      db.query(deleteQuery, (deleteErr) => {
        if (deleteErr) {
          console.error("Error during updating:", deleteErr);
          return;
        }
        console.log(`Update row with id: ${row.id}`);
      });
    });
  });
});
//
router.route("/register").post(async (req, res) => {
  const { email, name, phone, date, city } = req.body;
  var password = req.body.password.trim();
  var d = new Date(date);
  var image = "profile.png";

  // Check if email already exists
  const existingEmailQuery = "SELECT * FROM user WHERE email = ?";
  db.query(
    existingEmailQuery,
    [email],
    async (existingEmailError, existingEmailData) => {
      if (existingEmailError) {
        return res.send(
          JSON.stringify({ success: false, message: existingEmailError })
        );
      }

      if (existingEmailData.length > 0) {
        // Email already exists
        return res.send(
          JSON.stringify({ success: false, message: `${email} already exists` })
        );
      }

      // Check if name already exists
      const existingNameQuery = "SELECT * FROM user WHERE name = ?";
      db.query(
        existingNameQuery,
        [name],
        async (existingNameError, existingNameData) => {
          if (existingNameError) {
            return res.send(
              JSON.stringify({ success: false, message: existingNameError })
            );
          }

          if (existingNameData.length > 0) {
            // Name already exists
            return res.send(
              JSON.stringify({
                success: false,
                message: `${name} already exists`,
              })
            );
          }

          // Continue with user registration if email and name are not found
          const salt = await bcrypt.genSalt(10);
          let hashedPassword = await bcrypt.hash(password, salt);

          password = hashedPassword;

          var insertUserQuery =
            "INSERT INTO user(name,email,phone,date,city,password,image) VALUES (?,?,?,?,?,?,?)";

          db.query(
            insertUserQuery,
            [name, email, parseInt(phone), d, city, password, image],
            (insertUserError, data, fields) => {
              if (insertUserError) {
                // if error send response here
                res.send(
                  JSON.stringify({ success: false, message: insertUserError })
                );
              } else {
                // if success send response here
                res.send(
                  JSON.stringify({
                    success: true,
                    message: "Register successfully",
                  })
                );
              }
            }
          );
        }
      );
    }
  );
});

//
router.route("/login").post(async (req, res) => {
  var email = req.body.email.trim();
  var password = req.body.password.trim();

  var sql = "SELECT * FROM user WHERE email=?";

  if (email != "" && password != "") {
    db.query(sql, [email], async function (err, data, fields) {
      if (err) {
        res.send(JSON.stringify({ success: false, message: err }));
      } else {
        if (data.length > 0) {
          const hashedPassword = data[0].password;
          const passwordMatch = await bcrypt.compare(password, hashedPassword);
          if (passwordMatch) {
            res.send(JSON.stringify({ success: true, user: data }));
          } else {
            res.send(
              JSON.stringify({ success: false, message: "Incorrect password" })
            );
          }
        } else {
          res.send(
            JSON.stringify({ success: false, message: "User not found" })
          );
        }
      }
    });
  } else {
    res.send(
      JSON.stringify({
        success: false,
        message: "Email and password required!",
      })
    );
  }
});
//
router.route("/getUserId").get((req, res) => {
  var sql = "SELECT MAX(id) AS id FROM user";

  db.query(sql, function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res
          .status(200)
          .send(JSON.stringify({ success: true, ID: data[0]["id"] }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getServiceId").get((req, res) => {
  const { email, name } = req.query;
  if (!email || !name) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM business WHERE email = ? AND serviceName = ?";

  db.query(sql, [email, name], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res
          .status(200)
          .send(JSON.stringify({ success: true, id: data[0]["id"] }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/profile").get((req, res) => {
  const { email } = req.query;

  var sql = "SELECT * FROM user WHERE email=?";

  if (email != "") {
    db.query(sql, [email], function (err, data, fields) {
      if (err) {
        res.send(JSON.stringify({ success: false, message: err }));
      } else {
        if (data.length > 0) {
          res.send(JSON.stringify({ success: true, user: data }));
        } else {
          res.send(JSON.stringify({ success: false, message: "Empty Data" }));
        }
      }
    });
  } else {
    res.send(
      JSON.stringify({
        success: false,
        message: "Email not found",
      })
    );
  }
});
//
router.route("/Image").get((req, res) => {
  const { id } = req.query;

  var sql = "SELECT image FROM user WHERE id=?";

  if (id != "") {
    db.query(sql, [id], function (err, data, fields) {
      if (err) {
        res.send(JSON.stringify({ success: false, message: err }));
      } else {
        if (data.length > 0) {
          res.send(JSON.stringify({ success: true, user: data }));
        } else {
          res.send(JSON.stringify({ success: false, message: "Empty Data" }));
        }
      }
    });
  } else {
    res.send(
      JSON.stringify({
        success: false,
        message: "User not found",
      })
    );
  }
});
//
router.route("/serviceImage").get((req, res) => {
  const { id } = req.query;

  var sql = "SELECT serviceImg FROM business WHERE id=?";

  if (id != "") {
    db.query(sql, [id], function (err, data, fields) {
      if (err) {
        res.send(JSON.stringify({ success: false, message: err }));
      } else {
        if (data.length > 0) {
          res.send(JSON.stringify({ success: true, user: data }));
        } else {
          res.send(JSON.stringify({ success: false, message: "Empty Data" }));
        }
      }
    });
  } else {
    res.send(
      JSON.stringify({
        success: false,
        message: "User not found",
      })
    );
  }
});
//
router.route("/cardNum").get((req, res) => {
  const { email } = req.query;

  var sql = "SELECT Cnumber FROM card WHERE Uemail=?";

  if (email != "") {
    db.query(sql, [email], function (err, data, fields) {
      if (err) {
        res.send(JSON.stringify({ success: false, message: err }));
      } else {
        if (data.length > 0) {
          res.send(JSON.stringify({ success: true, cardNum: data }));
        } else {
          res.send(JSON.stringify({ success: false, message: "Empty Data" }));
        }
      }
    });
  } else {
    res.send(
      JSON.stringify({
        success: false,
        message: "Email not found",
      })
    );
  }
});
//
router.route("/updateProfile").post((req, res) => {
  const { email, name, phone, date, city } = req.body;

  if (!email || !name || !phone || !date || !city) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  const d = new Date(date);
  if (isNaN(d.getTime())) {
    return res.status(400).json({ success: false, message: "Invalid date." });
  }

  const sqlQuery =
    "UPDATE user SET name = ?, phone = ?, date = ?, city = ? WHERE email = ?";

  db.query(sqlQuery, [name, phone, d, city, email], (err, data, fields) => {
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

router.route("/changePassword").post(async (req, res) => {
  const { email, currentPass, password } = req.body;

  if (!email || !currentPass || !password) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  // Fetch the hashed password from the database
  const getPasswordQuery = "SELECT password FROM user WHERE email = ?";
  db.query(getPasswordQuery, [email], async (err, result, fields) => {
    if (err) {
      return res.status(500).json({ success: false, message: err });
    }
    const hashedPasswordInDB = result[0].password;

    // Compare the current password with the hashed password from the database
    const passwordMatch = await bcrypt.compare(currentPass, hashedPasswordInDB);

    if (!passwordMatch) {
      return res
        .status(401)
        .json({ success: false, message: "Incorrect current password." });
    }

    // If the current password is correct, update the password
    const salt = await bcrypt.genSalt(10);
    const newHashedPassword = await bcrypt.hash(password, salt);

    const updatePasswordQuery = "UPDATE user SET password = ? WHERE email = ?";
    db.query(
      updatePasswordQuery,
      [newHashedPassword, email],
      (updateErr, data, updateFields) => {
        if (updateErr) {
          return res.status(500).json({ success: false, message: updateErr });
        } else {
          return res
            .status(200)
            .json({ success: true, message: "Change password success" });
        }
      }
    );
  });
});

//
router.route("/addCard").post((req, res) => {
  const { uEmail, cNumber, cName, cCvv, cDate } = req.body;

  var sql =
    "INSERT INTO card(Uemail,Cnumber,Cname,Ccvv,Cdate) VALUES (?,?,?,?,?)";

  db.query(
    sql,
    [uEmail, cNumber, cName, cCvv, cDate],
    function (err, data, fields) {
      if (err) {
        res.send(JSON.stringify({ success: false, message: err }));
      } else {
        const sqlQuery = "UPDATE user SET card = ? WHERE email = ?";

        db.query(sqlQuery, [true, uEmail], (err, data, fields) => {
          if (err) {
            res.send(JSON.stringify({ success: false, message: err }));
          } else {
            res.send(
              JSON.stringify({
                success: true,
                message: "Added card successfully",
              })
            );
          }
        });
      }
    }
  );
});
//
router.route("/updateCard").post((req, res) => {
  const { email, card } = req.body;

  if (!email || !card) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  const sqlQuery = "UPDATE user SET card = ? WHERE email = ?";

  db.query(sqlQuery, [card, email], (err, data, fields) => {
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
router.route("/createBusiness").post((req, res) => {
  const { email, serviceName, serviceNo, serviceType, serviceCity } = req.body;
  const img = "cover.png";
  if (!email || !serviceName || !serviceNo || !serviceType || !serviceCity) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  const sqlQuery =
    "INSERT INTO business(email,serviceName,serviceNo,serviceType,serviceCity,serviceImg) VALUES (?,?,?,?,?,?)";

  db.query(
    sqlQuery,
    [email, serviceName, serviceNo, serviceType, serviceCity, img],
    (err, data, fields) => {
      if (err) {
        return res.status(500).json({ success: false, message: err });
      } else {
        return res
          .status(200)
          .json({ success: true, message: "Create Account Successfully" });
      }
    }
  );
});
//
router.route("/deleteCard").post((req, res) => {
  const { num } = req.body;

  if (!num) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  const sqlQuery = "DELETE FROM card WHERE Cnumber = ?";

  db.query(sqlQuery, [num], (err, data, fields) => {
    if (err) {
      return res.status(500).json({ success: false, message: err });
    } else {
      return res
        .status(200)
        .json({ success: true, message: "Delete Card Successfully" });
    }
  });
});
//
router.route("/businessList").get((req, res) => {
  const { email } = req.query;
  var sql = "SELECT * FROM business WHERE email=?";
  if (email != "") {
    db.query(sql, [email], function (err, data, fields) {
      if (err) {
        res.send(JSON.stringify({ success: false, message: err }));
      } else {
        if (data.length > 0) {
          res.send(JSON.stringify({ success: true, user: data }));
        } else {
          res.send(JSON.stringify({ success: false, message: "Empty Data" }));
        }
      }
    });
  } else {
    res.send(
      JSON.stringify({
        success: false,
        message: "Email not found",
      })
    );
  }
});
//
router.post("/upload", async (req, res) => {
  try {
    const { email, base64Image } = req.body;
    if (!req.body || !base64Image || !email) {
      throw new Error("Invalid request body");
    }

    const imageBuffer = Buffer.from(base64Image, "base64");

    const fileName = `image_${Date.now()}.png`;
    const filePath = path.join("uploads", fileName);
    fs.writeFileSync(path.join(__dirname, filePath), imageBuffer);

    sqlQuery = "UPDATE user SET image = ? WHERE email = ?";
    db.query(sqlQuery, [fileName, email], (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ success: false, message: err });
      } else {
        return res
          .status(200)
          .json({ success: true, message: "upload path to db successfully" });
      }
    });

    // res.status(200).json({ message: "Image saved successfully" });
  } catch (error) {
    //console.error(error);
    res.status(500).json({ success: false, message: error });
  }
});
//
router.post("/uploadB", async (req, res) => {
  try {
    const { name, base64Image } = req.body;
    if (!req.body || !base64Image || !name) {
      throw new Error("Invalid request body");
    }

    const imageBuffer = Buffer.from(base64Image, "base64");

    const fileName = `image_${Date.now()}.png`;
    const filePath = path.join("uploads", fileName);
    fs.writeFileSync(path.join(__dirname, filePath), imageBuffer);

    sqlQuery = "UPDATE business SET serviceImg = ? WHERE serviceName = ?";
    db.query(sqlQuery, [fileName, name], (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ success: false, message: err });
      } else {
        return res
          .status(200)
          .json({ success: true, message: "upload path to db successfully" });
      }
    });

    // res.status(200).json({ message: "Image saved successfully" });
  } catch (error) {
    //console.error(error);
    res.status(500).json({ success: false, message: error });
  }
});
//
router.route("/createNewPost").post((req, res) => {
  const {
    businessID,
    name,
    Details,
    city,
    Price,
    subImageCount,
    image,
    type,
    period,
    time,
  } = req.body;

  if (
    !businessID ||
    !name ||
    !Details ||
    !city ||
    !Price ||
    !subImageCount ||
    !image ||
    !type ||
    !period ||
    !time
  ) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  const timestr = time;
  timeparts = timestr.replace(" ", "").split("-");
  const startTime = moment(timeparts[0], "h:mm A");
  const endTime = moment(timeparts[1], "h:mm A");

  // Calculate the difference in hours and minutes
  const duration = moment.duration(endTime.diff(startTime));
  const hours = duration.hours();
  const minutes = duration.minutes();

  const maxResevation = hours / parseFloat(period);

  console.log(parseInt(maxResevation));

  console.log(`Difference: ${hours} hours and ${minutes} minutes`);

  const imageBuffer = Buffer.from(image, "base64");

  const fileName = `image_${Date.now()}_${businessID}.jpg`;
  const filePath = path.join("PostsMainImg", fileName);
  fs.writeFileSync(path.join(__dirname, filePath), imageBuffer);

  const sqlQuery =
    "INSERT INTO posts (userId,name, Details, City, type, price, mainImg, subImg, period, time , MaxReservation) VALUES (?,?,?,?,?,?,?,?,?,?,?)";

  db.query(
    sqlQuery,
    [
      businessID,
      name,
      Details,
      city,
      type,
      Price,
      fileName,
      subImageCount,
      period,
      time,
      maxResevation,
    ],
    (err, data, fields) => {
      if (err) {
        return res.status(500).json({ success: false, message: err });
      } else {
        return res.status(200).json({
          success: true,
          message: "Created Post Successfully",
        });
      }
    }
  );
});
//
router.route("/getPostId").get((req, res) => {
  const { userID } = req.query;

  if (!userID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT MAX(post_id) AS post_id FROM posts WHERE userId = ?";

  db.query(sql, [userID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res
          .status(200)
          .send(JSON.stringify({ success: true, ID: data[0]["post_id"] }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/addSubImg").post((req, res) => {
  const { postId, base64 } = req.body;

  if (!postId || !base64) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  const imageBuffer = Buffer.from(base64, "base64");

  const fileName = `image_${Date.now()}_${postId}.jpg`;
  const filePath = path.join("subImgFolder", fileName);
  fs.writeFileSync(path.join(__dirname, filePath), imageBuffer);

  const sqlQuery = "INSERT INTO subimg (post_id, subImg) VALUES (?,?)";

  db.query(sqlQuery, [postId, fileName], (err, data, fields) => {
    if (err) {
      return res.status(500).json({ success: false, message: err });
    } else {
      return res
        .status(200)
        .json({ success: true, message: "Add SubImg Successfully" });
    }
  });
});
//
router.route("/getPosts").get((req, res) => {
  const { userId } = req.query;

  if (!userId) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM posts WHERE userId = ?";

  db.query(sql, [userId], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, posts: data }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getSubImg").get((req, res) => {
  const { postID } = req.query;

  if (!postID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT subImg FROM subimg WHERE post_id = ?";

  db.query(sql, [postID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, images: data }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getSubImgOffer").get((req, res) => {
  const { offerID } = req.query;

  if (!offerID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT subImg FROM offerimg WHERE offer_id = ?";

  db.query(sql, [offerID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, images: data }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});

//
router.route("/createNewOffer").post((req, res) => {
  const {
    businessID,
    name,
    Details,
    city,
    oldPrice,
    newPrice,
    image,
    fromDate,
    toDate,
    subImageCount,
    type,
    period,
    time,
  } = req.body;

  if (
    !businessID ||
    !name ||
    !Details ||
    !city ||
    !oldPrice ||
    !newPrice ||
    !subImageCount ||
    !fromDate ||
    !toDate ||
    !image ||
    !type ||
    !period ||
    !time
  ) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  const imageBuffer = Buffer.from(image, "base64");

  const fileName = `image_Offer_${Date.now()}_${businessID}.jpg`;
  const filePath = path.join("PostsMainImg", fileName);
  fs.writeFileSync(path.join(__dirname, filePath), imageBuffer);

  const sqlQuery =
    "INSERT INTO offers (userId, name, Details, City, type, oldPrice, NewPrice, mainImg, fromDate, toDate, subImg, period, time) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";

  db.query(
    sqlQuery,
    [
      businessID,
      name,
      Details,
      city,
      type,
      oldPrice,
      newPrice,
      fileName,
      fromDate,
      toDate,
      subImageCount,
      period,
      time,
    ],
    (err, data, fields) => {
      if (err) {
        return res.status(500).json({ success: false, message: err });
      } else {
        return res
          .status(200)
          .json({ success: true, message: "Created Offer Successfully" });
      }
    }
  );
});
//
router.route("/getOfferId").get((req, res) => {
  const { userID } = req.query;

  if (!userID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT MAX(offer_id) AS offer_id FROM offers WHERE userId = ?";

  db.query(sql, [userID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res
          .status(200)
          .send(JSON.stringify({ success: true, ID: data[0]["offer_id"] }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/addSubImgOffer").post((req, res) => {
  const { offerId, base64 } = req.body;

  if (!offerId || !base64) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  const imageBuffer = Buffer.from(base64, "base64");

  const fileName = `image_Offer_${Date.now()}_${offerId}.jpg`;
  const filePath = path.join("subImgFolder", fileName);
  fs.writeFileSync(path.join(__dirname, filePath), imageBuffer);

  const sqlQuery = "INSERT INTO offerimg (offer_id, subImg) VALUES (?,?)";

  db.query(sqlQuery, [offerId, fileName], (err, data, fields) => {
    if (err) {
      return res.status(500).json({ success: false, message: err });
    } else {
      return res
        .status(200)
        .json({ success: true, message: "Add SubImg Successfully" });
    }
  });
});
//
router.route("/getOffers").get((req, res) => {
  const { userId } = req.query;

  if (!userId) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM offers WHERE userId = ?";

  db.query(sql, [userId], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, offers: data }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getAllPosts").get((req, res) => {
  const { type, city } = req.query;
  if (!type || !city) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM posts WHERE type = ? and city = ?";

  db.query(sql, [type, city], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, posts: data }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getAllOffers").get((req, res) => {
  const { type, city } = req.query;
  if (!type || !city) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM offers WHERE type = ? and city = ?";

  db.query(sql, [type, city], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, offers: data }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/addReviewPost").post((req, res) => {
  const { postID, userID, rating, text } = req.body;

  if (!postID || !userID || !rating || !text) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }
  const sql = "SELECT * FROM reviewposts WHERE post_id = ? and user_id = ?";
  db.query(sql, [postID, userID], (err, data, fields) => {
    if (err) {
      return res.status(500).json({ success: false, message: err });
    } else if (data.length > 0) {
      const sqlQUpdate = `UPDATE reviewposts SET rating = '${rating}',text = '${text}' WHERE post_id ='${postID}' AND user_id = '${userID}'`;
      db.query(sqlQUpdate, (err, data, fields) => {
        if (err) {
          return res.status(500).json({ success: false, message: err });
        } else {
          sqlRate = "SELECT * FROM reviewposts WHERE post_id = ?";
          db.query(sqlRate, [postID], (err, rating, fields) => {
            if (err) {
              return res.status(500).json({ success: false, message: err });
            } else {
              if (rating.length > 0) {
                var ratings = rating
                  .map((obj) => Number(obj.rating))
                  .filter(Number);
                var avg = ratings.reduce((acc, curr) => acc + curr, 0);
                avg /= ratings.length;
                sqlEdit = "UPDATE posts SET review = ? WHERE post_id = ?";
                db.query(sqlEdit, [avg, postID], (err, data, fields) => {
                  if (err) {
                    return res
                      .status(500)
                      .json({ success: false, message: err });
                  } else {
                    return res.status(200).json({
                      success: true,
                      message: "Update review Successfully",
                    });
                  }
                });
              }
            }
          });
        }
      });
    } else {
      const sqlQuery =
        "INSERT INTO reviewposts (post_id, user_id, rating, text) VALUES (?,?,?,?)";
      db.query(
        sqlQuery,
        [postID, userID, rating, text],
        (err, data, fields) => {
          if (err) {
            return res.status(500).json({ success: false, message: err });
          } else {
            sqlRate = "SELECT * FROM reviewposts WHERE post_id = ?";
            db.query(sqlRate, [postID], (err, rating, fields) => {
              if (err) {
                return res.status(500).json({ success: false, message: err });
              } else {
                if (rating.length > 0) {
                  var ratings = rating
                    .map((obj) => Number(obj.rating))
                    .filter(Number);
                  var avg = ratings.reduce((acc, curr) => acc + curr, 0);
                  avg /= ratings.length;
                  sqlEdit = "UPDATE posts SET review = ? WHERE post_id = ?";
                  db.query(sqlEdit, [avg, postID], (err, data, fields) => {
                    if (err) {
                      return res
                        .status(500)
                        .json({ success: false, message: err });
                    } else {
                      return res.status(200).json({
                        success: true,
                        message: "Update review Successfully",
                      });
                    }
                  });
                }
              }
            });
          }
        }
      );
    }
  });
});
//
router.route("/getReviews").get((req, res) => {
  const { postID } = req.query;
  if (!postID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM reviewposts WHERE post_id = ?";

  db.query(sql, [postID], function (err, data, fields) {
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
router.route("/getUserReviews").get((req, res) => {
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
router.route("/getReviewsOffer").get((req, res) => {
  const { offerID } = req.query;
  if (!offerID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM reviewoffers WHERE offer_id = ?";

  db.query(sql, [offerID], function (err, data, fields) {
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
router.route("/addReviewOffer").post((req, res) => {
  const { offerID, userID, rating, text } = req.body;

  if (!offerID || !userID || !rating || !text) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }
  const sql = "SELECT * FROM reviewoffers WHERE offer_id = ? and user_id = ?";
  db.query(sql, [offerID, userID], (err, data, fields) => {
    if (err) {
      return res.status(500).json({ success: false, message: err });
    } else if (data.length > 0) {
      const sqlQUpdate = `UPDATE reviewoffers SET rating = '${rating}',text = '${text}' WHERE offer_id ='${offerID}' AND user_id = '${userID}'`;
      db.query(sqlQUpdate, (err, data, fields) => {
        if (err) {
          return res.status(500).json({ success: false, message: err });
        } else {
          sqlRate = "SELECT * FROM reviewoffers WHERE offer_id = ?";
          db.query(sqlRate, [offerID], (err, rating, fields) => {
            if (err) {
              return res.status(500).json({ success: false, message: err });
            } else {
              if (rating.length > 0) {
                var ratings = [Number(rating)];
                var avg = ratings.reduce((acc, curr) => acc + curr, 0);
                avg /= ratings.length;
                console.log(avg);
                sqlEdit = "UPDATE offers SET review = ? WHERE offer_id = ?";
                db.query(sqlEdit, [avg, offerID], (err, data, fields) => {
                  if (err) {
                    return res
                      .status(500)
                      .json({ success: false, message: err });
                  } else {
                    return res.status(200).json({
                      success: true,
                      message: "Update review Successfully",
                    });
                  }
                });
              }
            }
          });
        }
      });
    } else {
      const sqlQuery =
        "INSERT INTO reviewoffers (offer_id, user_id, rating, text) VALUES (?,?,?,?)";

      db.query(
        sqlQuery,
        [offerID, userID, rating, text],
        (err, data, fields) => {
          if (err) {
            return res.status(500).json({ success: false, message: err });
          } else {
            if (rating.length > 0) {
              var ratings = [Number(rating)];
              var avg = ratings.reduce((acc, curr) => acc + curr, 0);
              avg /= ratings.length;
              console.log(avg);
              sqlEdit = "UPDATE offers SET review = ? WHERE offer_id = ?";
              db.query(sqlEdit, [avg, offerID], (err, data, fields) => {
                if (err) {
                  return res.status(500).json({ success: false, message: err });
                } else {
                  return res.status(200).json({
                    success: true,
                    message: "Update review Successfully",
                  });
                }
              });
            }
          }
        }
      );
    }
  });
});
//
router.post("/uploadAudio", upload.single("audioFile"), function (req, res) {
  if (!req.file) {
    return res.status(400).send("No file uploaded.");
  }

  try {
    console.log(`File saved as: ${req.file.filename}`);
    res.status(200).send("File uploaded successfully.");
  } catch (error) {
    console.error("Error processing file:", error);
    res.status(500).send("Internal Server Error");
  }
});
//
router.route("/addNewSong").post((req, res) => {
  const { businessId, songPath } = req.body;

  if (!businessId || !songPath) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  const sqlQuery = "INSERT INTO songs (user_id, song_path) VALUES (?,?)";

  db.query(sqlQuery, [businessId, songPath], (err, data, fields) => {
    if (err) {
      return res.status(500).json({ success: false, message: err });
    } else {
      return res
        .status(200)
        .json({ success: true, message: "Add song Successfully" });
    }
  });
});
//
router.route("/getMySong").get((req, res) => {
  const { businessID } = req.query;
  if (!businessID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM songs WHERE user_id = ?";

  db.query(sql, [businessID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, song: data }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.post("/uploadSongImg", async (req, res) => {
  try {
    const { name, base64Image } = req.body;
    if (!name || !base64Image) {
      res.status(400).json({ success: false, message: "Invalid input data" });
    }

    const imageBuffer = Buffer.from(base64Image, "base64");
    const fileName = `${name}.jpg`;
    const filePath = path.join("songImage", fileName);
    fs.writeFileSync(path.join(__dirname, filePath), imageBuffer);

    return res.status(200).json({
      success: true,
      message: "upload song Image to server successfully",
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error });
  }
});
//
router.route("/bookPost").post((req, res) => {
  const { postID, userID, date, start, end } = req.body;

  if (!postID || !userID || !date || !start || !end) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  const sqlQuery =
    "INSERT INTO book_post (user_id, post_id,date,start,end) VALUES (?,?,?,?,?)";

  db.query(
    sqlQuery,
    [userID, postID, date, start, end],
    (err, data, fields) => {
      if (err) {
        return res.status(500).json({ success: false, message: err });
      } else {
        return res
          .status(200)
          .json({ success: true, message: "Add book post Successfully" });
      }
    }
  );
});
//
router.route("/bookOffer").post((req, res) => {
  const { offerID, userID, date, start, end } = req.body;

  if (!offerID || !userID || !date || !start || !end) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  const sqlQuery =
    "INSERT INTO book_offer (user_id, offer_id,date,start,end) VALUES (?,?,?,?,?)";

  db.query(
    sqlQuery,
    [userID, offerID, date, start, end],
    (err, data, fields) => {
      if (err) {
        return res.status(500).json({ success: false, message: err });
      } else {
        return res
          .status(200)
          .json({ success: true, message: "Add book post Successfully" });
      }
    }
  );
});
//
router.route("/getBookPost").get((req, res) => {
  const { userID } = req.query;
  if (!userID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM book_post WHERE user_id = ?";

  db.query(sql, [userID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, post: data }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getBookOffer").get((req, res) => {
  const { userID } = req.query;
  if (!userID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM book_offer WHERE user_id = ?";

  db.query(sql, [userID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, offer: data }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getPostByID").get((req, res) => {
  const { postID } = req.query;
  if (!postID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM posts WHERE post_id = ?";

  db.query(sql, [postID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, post: data }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getOfferByID").get((req, res) => {
  const { offerID } = req.query;
  if (!offerID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM offers WHERE offer_id = ?";

  db.query(sql, [offerID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, offer: data }));
      } else {
        res.send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/deletePostB").post((req, res) => {
  const { userID, postID } = req.body;

  if (!userID || !postID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  const sqlQuery = "DELETE FROM book_post WHERE user_id = ? AND post_id = ?";

  db.query(sqlQuery, [userID, postID], (err, data, fields) => {
    if (err) {
      return res.status(500).json({ success: false, message: err });
    } else {
      return res
        .status(200)
        .json({ success: true, message: "Delete book post Successfully" });
    }
  });
});
//
router.route("/deleteOfferB").post((req, res) => {
  const { userID, offerID } = req.body;

  if (!userID || !offerID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  const sqlQuery = "DELETE FROM book_offer WHERE user_id = ? AND offer_id = ?";

  db.query(sqlQuery, [userID, offerID], (err, data, fields) => {
    if (err) {
      return res.status(500).json({ success: false, message: err });
    } else {
      return res
        .status(200)
        .json({ success: true, message: "Delete book offer Successfully" });
    }
  });
});
//
router.route("/forget").post(async (req, res) => {
  try {
    const email = req.body.email.trim();
    const checkEmailQuery = `SELECT * FROM user WHERE email='${email}'`;
    db.query(checkEmailQuery, (err, result) => {
      if (err) {
        return res
          .status(500)
          .json({ success: false, message: "Database error." });
      }

      if (!result || result.length === 0) {
        return res
          .status(404)
          .json({ success: false, message: "Email not found." });
      }
      const code = Math.floor(Math.random() * 9000) + 1000;
      const updateCodeQuery = `UPDATE user SET verification_code='${code}' WHERE email='${email}';`;
      db.query(updateCodeQuery, (updateErr) => {
        if (updateErr) {
          return res.status(500).json({
            success: false,
            message: "Error updating verification code.",
          });
        }

        const transporter = nodemailer.createTransport({
          service: "gmail",
          auth: {
            user: /*'zayddwik@gmail.com',*/ `${process.env.EMAIL}`,
            pass: /*'jqsu kcpk aibt accf',*/ `${process.env.PASSWORD}`,
          },
          tls: {
            rejectUnauthorized: false,
          },
        });

        console.log(`${process.env.EMAIL}`);
        console.log(`${process.env.PASSWORD}`);

        const mailOptions = {
          from: `${process.env.EMAIL}`,
          to: email,
          subject: "Verification Code for Party Planner App!",
          text: `Your verification code is ${code}`,
        };

        transporter.sendMail(mailOptions, (mailErr) => {
          if (mailErr) {
            return res
              .status(500)
              .json({ success: false, message: "Error in sending email." });
          }

          console.log("The email has been sent");
          return res.status(200).json({
            success: true,
            message:
              "Verification code has been sent to your registered email.",
          });
        });
      });
    });
  } catch (error) {
    console.error(error);
    return res
      .status(500)
      .json({ success: false, message: "Internal server error." });
  }
});
//
router.route("/CheckCode").post(async (req, res) => {
  try {
    const { email, code } = req.body;
    const intCode = parseInt(code);
    const checkCodeQuery = `SELECT * FROM user WHERE email='${email}' AND verification_code='${intCode}';`;

    db.query(checkCodeQuery, (checkErr, result) => {
      if (checkErr) {
        return res.status(500).json({
          success: false,
          message: "Error checking verification code.",
        });
      }

      if (result.length === 0) {
        return res
          .status(400)
          .json({ success: false, message: "Verification code is incorrect." });
      }
      return res
        .status(200)
        .json({ success: true, message: "Verification code is correct." });
    });
  } catch (error) {
    console.error(error);
    return res
      .status(500)
      .json({ success: false, message: "Internal server error." });
  }
});
//
router.route("/resetPassword").post(async (req, res) => {
  const email = req.body.email.trim();
  var password = req.body.password.trim();
  if (!email || !password) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(password, salt);

  password = hashedPassword;

  const sqlQuery = "UPDATE user SET password = ? WHERE email = ?";
  db.query(sqlQuery, [password, email], (err, data, fields) => {
    if (err) {
      return res.status(500).json({ success: false, message: err });
    } else {
      return res
        .status(200)
        .json({ success: true, message: "Reset password success" });
    }
  });
});
//
router.route("/confirmBook").post((req, res) => {
  const { serviceID, userID, postID, offerID, date, time } = req.body;
  const status = "waiting";
  if (!serviceID || !userID || !postID || !offerID || !date || !time) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }
  var sql =
    "INSERT INTO reservation(serviceID,user_id,post_id,offer_id,date,time,status) VALUES (?,?,?,?,?,?,?)";

  db.query(
    sql,
    [serviceID, userID, postID, offerID, date, time, status],
    function (err, data, fields) {
      if (err) {
        res.send(JSON.stringify({ success: false, message: err }));
      } else {
        res.send(
          JSON.stringify({
            success: true,
            message: "Added books successfully",
          })
        );
      }
    }
  );
});
//
router.route("/getReservations").get((req, res) => {
  const { userID, date } = req.query;
  if (!userID || !date) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM reservation WHERE user_id = ? AND date = ?";

  db.query(sql, [userID, date], function (err, data, fields) {
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
router.route("/getResDate").get((req, res) => {
  const { userID } = req.query;
  if (!userID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT date FROM reservation WHERE user_id = ? ";

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
router.route("/getResServiceDate").get((req, res) => {
  const { userID } = req.query;
  if (!userID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql =
    "SELECT date FROM reservation WHERE serviceID = ? AND status = 'Confirmed'";

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
router.route("/getServiceIDPost").get((req, res) => {
  const { postID } = req.query;
  if (!postID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT userId FROM posts WHERE post_id = ?";

  db.query(sql, [postID], function (err, data, fields) {
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
router.route("/getServiceIDOffer").get((req, res) => {
  const { offerID } = req.query;
  if (!offerID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT userId FROM offers WHERE offer_id = ?";

  db.query(sql, [offerID], function (err, data, fields) {
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
router.route("/getReservationsService").get((req, res) => {
  const { userID, date } = req.query;
  if (!userID || !date) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM reservation WHERE serviceID = ? AND date = ?";

  db.query(sql, [userID, date], function (err, data, fields) {
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
router.route("/changeStatusRes").post((req, res) => {
  const { serviceID, userID, postID, offerID, time, date, status } = req.body;

  if (
    !serviceID ||
    !userID ||
    !postID ||
    !offerID ||
    !time ||
    !date ||
    !status
  ) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }
  var sql =
    "UPDATE reservation SET status = ? WHERE serviceID = ? AND user_id = ? AND post_id =? AND offer_id =? AND date =? AND time = ? ";

  db.query(
    sql,
    [status, serviceID, userID, postID, offerID, date, time],
    function (err, data, fields) {
      if (err) {
        res.send(JSON.stringify({ success: false, message: err }));
      } else {
        if (status == "Confirmed") {
          res.send(
            JSON.stringify({
              success: true,
              message: "Confirmed book successfully",
            })
          );
        } else {
          res.send(
            JSON.stringify({
              success: true,
              message: "Canceled book successfully",
            })
          );
        }
      }
    }
  );
});
//
router.route("/getDisable").get((req, res) => {
  const { postID, date } = req.query;
  if (!postID || !date) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql =
    "SELECT time FROM reservation WHERE post_id = ? AND date = ? AND status = 'Confirmed'";

  db.query(sql, [postID, date], function (err, data, fields) {
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
router.route("/getDisableOffer").get((req, res) => {
  const { offerID, date } = req.query;
  if (!offerID || !date) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql =
    "SELECT time FROM reservation WHERE offer_id = ? AND date = ? AND status = 'Confirmed'";

  db.query(sql, [offerID, date], function (err, data, fields) {
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
router.route("/getProfileBusiness").get((req, res) => {
  const { userID } = req.query;
  if (!userID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM business WHERE id = ? ";

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
router.route("/updateBusinessProfile").post((req, res) => {
  const { serviceName, bio, serviceNo, holidays, businessID } = req.body;

  if (!serviceName || !bio || !serviceNo || !businessID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }
  var sql =
    "UPDATE business SET serviceName =?, serviceNo =?, bio =?, holidays =? WHERE id =?";

  db.query(
    sql,
    [serviceName, serviceNo, bio, holidays, businessID],
    function (err, data, fields) {
      if (err) {
        res.send(JSON.stringify({ success: false, message: err }));
      } else {
        res.send(
          JSON.stringify({
            success: true,
            message: "Updated profile successfully",
          })
        );
      }
    }
  );
});
//
router.route("/getServiceIDPost").get((req, res) => {
  const { postID } = req.query;
  if (!postID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM posts WHERE post_id = ? ";

  db.query(sql, [postID], function (err, data, fields) {
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
router.route("/getServiceOfferID").get((req, res) => {
  const { offerID } = req.query;
  if (!offerID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM offers WHERE offer_id = ? ";

  db.query(sql, [offerID], function (err, data, fields) {
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
//search
router.route("/accountServiceCity").get((req, res) => {
  const { type, city } = req.query;

  if (type.length != 0 && city.length != 0) {
    var sql =
      "SELECT * FROM business WHERE serviceType = ? AND serviceCity = ?";
    db.query(sql, [type, city], function (err, data, fields) {
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
  } else if (type.length != 0 && city.length == 0) {
    var sql = "SELECT * FROM business WHERE serviceType = ?";
    db.query(sql, [type], function (err, data, fields) {
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
  } else if (type.length == 0 && city.length != 0) {
    var sql = "SELECT * FROM business WHERE serviceCity = ?";
    db.query(sql, [city], function (err, data, fields) {
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
  } else {
    var sql = "SELECT * FROM business";
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
  }
});
//
router.route("/postServiceCity").get((req, res) => {
  const { type, city, startPrice, endPrice } = req.query;
  if (!startPrice || !endPrice) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }
  if (type.length != 0 && city != 0) {
    var sql =
      "SELECT * FROM posts WHERE type = ? AND City = ? AND price BETWEEN ? AND ?";
    db.query(
      sql,
      [type, city, startPrice, endPrice],
      function (err, data, fields) {
        if (err) {
          res.send(JSON.stringify({ success: false, message: err }));
        } else {
          if (data.length > 0) {
            res.status(200).send(JSON.stringify({ success: true, data: data }));
          } else {
            res.send(JSON.stringify({ success: false, message: "Empty Data" }));
          }
        }
      }
    );
  } else if (type.length != 0 && city == 0) {
    var sql = "SELECT * FROM posts WHERE type = ? AND price BETWEEN ? AND ?";
    db.query(sql, [type, startPrice, endPrice], function (err, data, fields) {
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
  } else if (type.length == 0 && city != 0) {
    var sql = "SELECT * FROM posts WHERE City = ? AND price BETWEEN ? AND ?";
    db.query(sql, [city, startPrice, endPrice], function (err, data, fields) {
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
  } else {
    var sql = "SELECT * FROM posts WHERE price BETWEEN ? AND ?";
    db.query(sql, [startPrice, endPrice], function (err, data, fields) {
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
  }
});
//
router.route("/offerServiceCity").get((req, res) => {
  const { type, city, startPrice, endPrice } = req.query;
  if (!startPrice || !endPrice) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }
  if (type.length != 0 && city != 0) {
    var sql =
      "SELECT * FROM offers WHERE type = ? AND City = ? AND NewPrice BETWEEN ? AND ?";
    db.query(
      sql,
      [type, city, startPrice, endPrice],
      function (err, data, fields) {
        if (err) {
          res.send(JSON.stringify({ success: false, message: err }));
        } else {
          if (data.length > 0) {
            res.status(200).send(JSON.stringify({ success: true, data: data }));
          } else {
            res.send(JSON.stringify({ success: false, message: "Empty Data" }));
          }
        }
      }
    );
  } else if (type.length != 0 && city == 0) {
    var sql =
      "SELECT * FROM offers WHERE type = ? AND NewPrice BETWEEN ? AND ?";
    db.query(sql, [type, startPrice, endPrice], function (err, data, fields) {
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
  } else if (type.length == 0 && city != 0) {
    var sql =
      "SELECT * FROM offers WHERE City = ? AND NewPrice BETWEEN ? AND ?";
    db.query(sql, [city, startPrice, endPrice], function (err, data, fields) {
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
  } else {
    var sql = "SELECT * FROM offers WHERE NewPrice BETWEEN ? AND ?";
    db.query(sql, [startPrice, endPrice], function (err, data, fields) {
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
  }
});
//
router.route("/getRecommendPost").get((req, res) => {
  var sql =
    "SELECT * FROM posts ORDER BY review DESC , liked DESC, visits DESC";

  db.query(sql, function (err, data, fields) {
    if (err) {
      return res.json({ success: false, message: err });
    }

    if (data.length > 0) {
      res.json({ success: true, data: data });
    } else {
      res.json({ success: false, message: "Empty Data" });
    }
  });
});
//
router.route("/setVisitPost").post((req, res) => {
  const { postID } = req.body;

  if (!postID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }
  var sql = "UPDATE posts SET visits = visits + 1 WHERE post_id = ?";

  db.query(sql, [postID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      res.send(
        JSON.stringify({
          success: true,
          message: "Updated visits successfully",
        })
      );
    }
  });
});
//
router.route("/setVisitOffer").post((req, res) => {
  const { offerID } = req.body;

  if (!offerID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }
  var sql = "UPDATE offers SET visits = visits + 1 WHERE offer_id = ?";

  db.query(sql, [offerID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      res.send(
        JSON.stringify({
          success: true,
          message: "Updated visits successfully",
        })
      );
    }
  });
});
//
router.route("/getIfFavorite").get((req, res) => {
  const { userID, postID, offerID } = req.query;
  if (!userID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql =
    "SELECT * FROM favorite WHERE user_id =? AND post_id = ? AND offer_id =?";

  db.query(sql, [userID, postID, offerID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, data: true }));
      } else {
        res.status(200).send(JSON.stringify({ success: true, data: false }));
      }
    }
  });
});
//
router.route("/addFavorite").post(async (req, res) => {
  const { userID, postID, offerID } = req.body;

  if (!userID) {
    return res
      .status(400)
      .json({ success: false, message: "Input Field is required" });
  }

  let addFavSQL =
    "INSERT INTO favorite (user_id, post_id, offer_id) VALUES (?, ?, ?)";
  db.query(addFavSQL, [userID, postID, offerID], function (err, result) {
    if (err) {
      return res.json({
        success: false,
        message: err,
      });
    } else {
      return res.json({
        success: true,
        message: "Added To Your Favorites",
      });
    }
  });
});
//
router.route("/removeFavorite").post(async (req, res) => {
  const { userID, postID, offerID } = req.body;

  if (!userID) {
    return res
      .status(400)
      .json({ success: false, message: "Input Field is required" });
  }

  let addFavSQL =
    "DELETE FROM favorite WHERE user_id = ? AND post_id = ? AND offer_id = ?";
  db.query(addFavSQL, [userID, postID, offerID], function (err, result) {
    if (err) {
      return res.json({
        success: false,
        message: err,
      });
    } else {
      return res.json({
        success: true,
        message: "removed From Your Favorites",
      });
    }
  });
});
//
router.route("/getFavorite").get((req, res) => {
  const { userID } = req.query;
  if (!userID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM favorite WHERE user_id =?";

  db.query(sql, [userID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, data: data }));
      } else {
        res
          .status(404)
          .send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getHoliday").get((req, res) => {
  const { postID } = req.query;
  if (!postID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT userId FROM posts WHERE post_id =?";

  db.query(sql, [postID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      console.log(data[0]["userId"]);
      if (data[0]["userId"] > 0) {
        var newSql = "SELECT holidays FROM business WHERE id = ?";
        db.query(newSql, [data[0]["userId"]], function (err, holiday, fields) {
          if (err) {
            res.send(JSON.stringify({ success: false, message: err }));
          } else {
            res
              .status(200)
              .send(
                JSON.stringify({ success: true, data: holiday[0]["holidays"] })
              );
          }
        });
      } else {
        res
          .status(200)
          .send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getHolidayOffer").get((req, res) => {
  const { offerID } = req.query;
  if (!offerID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT userId FROM offers WHERE offer_id =?";

  db.query(sql, [offerID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data[0]["userId"] > 0) {
        var newSql = "SELECT holidays FROM business WHERE id = ?";
        db.query(newSql, [data[0]["userId"]], function (err, holiday, fields) {
          if (err) {
            res.send(JSON.stringify({ success: false, message: err }));
          } else {
            res
              .status(200)
              .send(
                JSON.stringify({ success: true, data: holiday[0]["holidays"] })
              );
          }
        });
      } else {
        res
          .status(200)
          .send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getTimePost").get((req, res) => {
  const { postID } = req.query;
  if (!postID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT period, time FROM posts WHERE post_id =?";

  db.query(sql, [postID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, data: data }));
      } else {
        res
          .status(200)
          .send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getFullPosts").get((req, res) => {
  const { postID } = req.query;
  if (!postID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT date FROM reservation WHERE post_id =?";

  db.query(sql, [postID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, data: data }));
      } else {
        res
          .status(200)
          .send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getFullOffers").get((req, res) => {
  const { offerID } = req.query;
  if (!offerID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT date FROM reservation WHERE offer_id =?";

  db.query(sql, [offerID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, data: data }));
      } else {
        res
          .status(200)
          .send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getTimeOffer").get((req, res) => {
  const { offerID } = req.query;
  if (!offerID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT period, time FROM offers WHERE offer_id =?";

  db.query(sql, [offerID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, data: data }));
      } else {
        res
          .status(200)
          .send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getNumPost").get((req, res) => {
  const { userID } = req.query;
  if (!userID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM posts WHERE userId =?";

  db.query(sql, [userID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res
          .status(200)
          .send(JSON.stringify({ success: true, data: data.length }));
      } else {
        res
          .status(404)
          .send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getNumOffer").get((req, res) => {
  const { userID } = req.query;
  if (!userID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM offers WHERE userId =?";

  db.query(sql, [userID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res
          .status(200)
          .send(JSON.stringify({ success: true, data: data.length }));
      } else {
        res
          .status(404)
          .send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getEarn").get(async (req, res) => {
  const { userID } = req.query;
  if (!userID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  try {
    const data = await new Promise((resolve, reject) => {
      var sql =
        "SELECT * FROM reservation WHERE serviceID = ? AND status ='Confirmed'";
      db.query(sql, [userID], (err, data, fields) => {
        if (err) {
          reject(err);
        } else {
          resolve(data);
        }
      });
    });

    if (data.length > 0) {
      var count = 0;

      for (var i = 0; i < data.length; i++) {
        var inputDateString = data[i]["date"];
        var inputDate = new Date(inputDateString);
        var currentDate = new Date();

        if (inputDate.getMonth() === currentDate.getMonth()) {
          if (data[i]["post_id"] != 0) {
            var postData = await new Promise((resolve, reject) => {
              var sql2 = "SELECT price FROM posts WHERE post_id =?";
              db.query(sql2, [data[i]["post_id"]], (err, postData, fields) => {
                if (err) {
                  reject(err);
                } else {
                  resolve(postData);
                }
              });
            });

            count += postData[0]["price"];
          } else {
            var offerData = await new Promise((resolve, reject) => {
              var sql2 = "SELECT NewPrice FROM offers WHERE offer_id =?";
              db.query(
                sql2,
                [data[i]["offer_id"]],
                (err, offerData, fields) => {
                  if (err) {
                    reject(err);
                  } else {
                    resolve(offerData);
                  }
                }
              );
            });

            count += offerData[0]["NewPrice"];
          }
        }
      }

      res.status(200).send(JSON.stringify({ success: true, data: count }));
    } else {
      res.status(404).send(JSON.stringify({ success: true, data: 0 }));
    }
  } catch (error) {
    res
      .status(500)
      .send(JSON.stringify({ success: false, message: error.message }));
  }
});
//
router.route("/sendFeedback").post(async (req, res) => {
  const { userID, text, rate } = req.body;

  if (!userID || !text || !rate) {
    return res
      .status(400)
      .json({ success: false, message: "Input Field is required" });
  }

  let checkIfExistsSql = "SELECT * FROM feedback WHERE user_id = ?";
  db.query(checkIfExistsSql, [userID], function (err, rows) {
    if (err) {
      return res.json({
        success: false,
        message: err,
      });
    }

    if (rows.length > 0) {
      let updateSql =
        "UPDATE feedback SET text = ?, rate = ? WHERE user_id = ?";
      db.query(updateSql, [text, rate, userID], function (err, result) {
        if (err) {
          return res.json({
            success: false,
            message: err,
          });
        } else {
          return res.json({
            success: true,
            message: "Feedback updated successfully",
          });
        }
      });
    } else {
      let insertSql =
        "INSERT INTO feedback(user_id, text, rate) VALUES (?, ?, ?)";
      db.query(insertSql, [userID, text, rate], function (err, result) {
        if (err) {
          return res.json({
            success: false,
            message: err,
          });
        } else {
          return res.json({
            success: true,
            message: "Feedback inserted successfully",
          });
        }
      });
    }
  });
});
//
router.route("/sendReport").post(async (req, res) => {
  const { email, id, message } = req.body;

  if (!email || !id || !message) {
    return res
      .status(400)
      .json({ success: false, message: "Input Field is required" });
  }

  let sql = "INSERT INTO reports(email,serviceID,text) VALUES (?,?,?)";
  db.query(sql, [email, id, message], function (err, result) {
    if (err) {
      return res.json({
        success: false,
        message: err,
      });
    } else {
      let sqlQuery =
        " UPDATE business SET reports_Counter = reports_Counter + 1,active = CASE WHEN reports_Counter + 1 >= 50 THEN 0 ELSE active END,Susbend_Account = CASE WHEN reports_Counter + 1 >= 50 THEN 1 ELSE Susbend_Account END WHERE id = ?;";

      db.query(sqlQuery, [id], (error, result1) => {
        if (error) {
          return res
            .status(500)
            .json({ success: flase, message: "failed increase the Counter !" });
        } else {
          return res.json({
            success: true,
            message: "send report successfully",
          });
        }
      });
    }
  });
});
//
router.route("/postNotification").post(async (req, res) => {
  const { userID, serviceID, text, date, flag } = req.body;
  var flg = 0;
  if ((!userID, !serviceID, !text, !date)) {
    return res
      .status(400)
      .json({ success: false, message: "Input Field is required" });
  }
  if (flag == "true") {
    flg = 1;
  }
  let sql =
    "INSERT INTO notification(user_id,user2_id,text,date,flag) VALUES (?,?,?,?,?)";
  db.query(sql, [userID, serviceID, text, date, flg], function (err, result) {
    if (err) {
      return res.json({
        success: false,
        message: err,
      });
    } else {
      return res.json({
        success: true,
        message: "send notification successfully",
      });
    }
  });
});
//
router.route("/postServiceNotification").post(async (req, res) => {
  const { serviceID, userID, text, date } = req.body;

  if ((!userID, !serviceID, !text, !date)) {
    return res
      .status(400)
      .json({ success: false, message: "Input Field is required" });
  }

  let sql =
    "INSERT INTO services_notification(service_id,user_id,text,date) VALUES (?,?,?,?)";
  db.query(sql, [serviceID, userID, text, date], function (err, result) {
    if (err) {
      return res.json({
        success: false,
        message: err,
      });
    } else {
      return res.json({
        success: true,
        message: "send notification successfully",
      });
    }
  });
});
//
router.route("/getUserServiceId").get((req, res) => {
  const { serviceID } = req.query;
  if (!serviceID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT email FROM business WHERE id =?";

  db.query(sql, [serviceID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data != "") {
        var sql2 = "SELECT id FROM user WHERE email =?";
        db.query(sql2, [data[0]["email"]], function (error, id, fields) {
          if (error) {
            res.send(JSON.stringify({ success: false, message: err }));
          } else {
            res
              .status(200)
              .send(JSON.stringify({ success: true, data: id[0]["id"] }));
          }
        });
      } else {
        res
          .status(404)
          .send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getUserNotifications").get((req, res) => {
  const { userID } = req.query;
  if (!userID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM notification WHERE user_id =?";

  db.query(sql, [userID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, data: data }));
      } else {
        res
          .status(200)
          .send(
            JSON.stringify({ success: false, message: "No Notification yet" })
          );
      }
    }
  });
});
//
router.route("/getServiceNotifications").get((req, res) => {
  const { serviceID } = req.query;
  if (!serviceID) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM services_notification WHERE service_id =?";

  db.query(sql, [serviceID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        res.status(200).send(JSON.stringify({ success: true, data: data }));
      } else {
        res
          .status(200)
          .send(
            JSON.stringify({ success: false, message: "No Notification yet" })
          );
      }
    }
  });
});
//
router.route("/ReservationCount").get((req, res) => {
  const { serviceID, year } = req.query;
  if (!serviceID || !year) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT * FROM reservation WHERE serviceID =?";
  var list = [];
  var Canceled = 0;
  var Confirmed = 0;
  var Waiting = 0;
  db.query(sql, [serviceID], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data.length > 0) {
        for (var i = 0; i < data.length; i++) {
          var dateToCheck = new Date(data[i]["date"]);

          if (
            data[i]["status"] == "Canceled" &&
            year == dateToCheck.getFullYear()
          ) {
            Canceled++;
          } else if (
            data[i]["status"] == "Confirmed" &&
            year == dateToCheck.getFullYear()
          ) {
            Confirmed++;
          } else if (year == dateToCheck.getFullYear()) {
            Waiting++;
          }
        }
        list.push({
          Waiting: Waiting,
          Confirmed: Confirmed,
          Canceled: Canceled,
        });
        res.status(200).send(JSON.stringify({ success: true, data: list }));
      } else {
        res
          .status(200)
          .send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getEarnMoney").get(async (req, res) => {
  const { serviceID, year } = req.query;
  if (!serviceID || !year) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql =
    "SELECT * FROM reservation WHERE serviceID =? AND status = 'Confirmed'";
  var list = [];

  try {
    const data = await new Promise((resolve, reject) => {
      db.query(sql, [serviceID], function (err, data, fields) {
        if (err) {
          reject(err);
        } else {
          resolve(data);
        }
      });
    });

    if (data.length > 0) {
      const chickYear = new Date().getFullYear();
      const currentMonth = new Date().getMonth();
      if (year == chickYear) {
        for (var m = 0; m <= currentMonth; m++) {
          var count = 0;
          for (var i = 0; i < data.length; i++) {
            var currentDate = new Date();
            var currentYear = currentDate.getFullYear();
            var dateToCheck = new Date(data[i]["date"]);
            var yearToCheck = dateToCheck.getFullYear();
            var monthToCheck = dateToCheck.getMonth();

            if (currentYear === yearToCheck && m === monthToCheck) {
              if (data[i]["post_id"] !== 0) {
                var sql2 = "SELECT price FROM posts WHERE post_id =? ";
                const result = await new Promise((resolve, reject) => {
                  db.query(
                    sql2,
                    [data[i]["post_id"]],
                    function (err, data, fields) {
                      if (err) {
                        reject(err);
                      } else {
                        resolve(data[0]["price"]);
                      }
                    }
                  );
                });
                count += result;
              } else {
                var sql2 = "SELECT NewPrice FROM offers WHERE offer_id =? ";
                const result = await new Promise((resolve, reject) => {
                  db.query(
                    sql2,
                    [data[i]["offer_id"]],
                    function (err, data, fields) {
                      if (err) {
                        reject(err);
                      } else {
                        resolve(data[0]["NewPrice"]);
                      }
                    }
                  );
                });
                count += result;
              }
            }
          }

          list.push(count);
        }
      } else {
        console.log(data);
        for (var m = 0; m <= 11; m++) {
          var count = 0;
          for (var i = 0; i < data.length; i++) {
            var currentDate = new Date();
            var dateToCheck = new Date(data[i]["date"]);
            var monthToCheck = dateToCheck.getMonth();
            var currentYear = dateToCheck.getFullYear();

            if (currentYear == year && m == monthToCheck) {
              if (data[i]["post_id"] !== 0) {
                var sql2 = "SELECT price FROM posts WHERE post_id =? ";
                const result = await new Promise((resolve, reject) => {
                  db.query(
                    sql2,
                    [data[i]["post_id"]],
                    function (err, data, fields) {
                      if (err) {
                        reject(err);
                      } else {
                        resolve(data[0]["price"]);
                      }
                    }
                  );
                });
                count += result;
              } else {
                var sql2 = "SELECT NewPrice FROM offers WHERE offer_id =? ";
                const result = await new Promise((resolve, reject) => {
                  db.query(
                    sql2,
                    [data[i]["offer_id"]],
                    function (err, data, fields) {
                      if (err) {
                        reject(err);
                      } else {
                        resolve(data[0]["NewPrice"]);
                      }
                    }
                  );
                });
                count += result;
              }
            }
          }
          list.push(count);
        }
      }

      res.status(200).send(JSON.stringify({ success: true, data: list }));
    } else {
      res
        .status(200)
        .send(JSON.stringify({ success: false, message: "Empty Data" }));
    }
  } catch (error) {
    res.send(JSON.stringify({ success: false, message: error }));
  }
});
//
router.route("/recommenderSystem").post(async (req, res) => {
  try {
    const {
      signer,
      photo,
      Decorating,
      Chair_rental,
      Stage_rental,
      Restaurant,
      Organizer,
      value,
      SelectedDate,
    } = req.body;

    const singer_val = (value * signer) / 100;
    const photo_val = (value * photo) / 100;
    const decorating_val = (value * Decorating) / 100;
    const Chair_rental_val = (value * Chair_rental) / 100;
    const Stage_rental_val = (value * Stage_rental) / 100;
    const Restaurant_val = (value * Restaurant) / 100;
    const Organizer_val = (value * Organizer) / 100;

    const fetch_data = async (sqlQuery, parameters) => {
      try {
        const result1 = await new Promise((resolve, reject) => {
          db.query(sqlQuery, [parameters], (err, result1) => {
            if (err) {
              reject(err);
            } else {
              console.log(result1);
              console.log(parameters);
              console.log(sqlQuery);
              resolve(result1);
            }
          });
        });

        return result1;
      } catch (error) {
        throw error;
      }
    };

    const result2 = await fetch_data(
      `SELECT p.*, COUNT(res.post_id) AS reservation_count 
      FROM posts p 
      LEFT JOIN reservation res ON p.post_id = res.post_id AND res.date = "${SelectedDate}" 
      WHERE p.price <= ? 
        AND (res.date IS NULL OR p.MaxReservation > (SELECT COUNT(*) FROM reservation WHERE post_id = p.post_id AND date = "${SelectedDate}")) 
        AND p.type = "Studio" 
        AND p.review >= 1 
      GROUP BY p.post_id 
      ORDER BY p.price DESC; 
      `,
      [[photo_val]]
    );
    const result3 = await fetch_data(
      `SELECT p.*, COUNT(res.post_id) AS reservation_count 
      FROM posts p 
      LEFT JOIN reservation res ON p.post_id = res.post_id AND res.date = "${SelectedDate}" 
      WHERE p.price <= ? 
        AND (res.date IS NULL OR p.MaxReservation > (SELECT COUNT(*) FROM reservation WHERE post_id = p.post_id AND date = "${SelectedDate}")) 
        AND p.type in ("Singer", "DJ") 
        AND p.review >= 1 
      GROUP BY p.post_id 
      ORDER BY p.price DESC`,
      [[singer_val]]
    );
    const result4 = await fetch_data(
      `SELECT p.*, COUNT(res.post_id) AS reservation_count 
      FROM posts p 
      LEFT JOIN reservation res ON p.post_id = res.post_id AND res.date = "${SelectedDate}" 
      WHERE p.price <= ? 
        AND (res.date IS NULL OR p.MaxReservation > (SELECT COUNT(*) FROM reservation WHERE post_id = p.post_id AND date = "${SelectedDate}")) 
        AND p.type = "Decorating" 
        AND p.review >= 1 
      GROUP BY p.post_id 
      ORDER BY p.price DESC`,
      [[decorating_val]]
    );
    const result5 = await fetch_data(
      `SELECT p.*, COUNT(res.post_id) AS reservation_count 
      FROM posts p 
      LEFT JOIN reservation res ON p.post_id = res.post_id AND res.date = "${SelectedDate}" 
      WHERE p.price <= ? 
        AND (res.date IS NULL OR p.MaxReservation > (SELECT COUNT(*) FROM reservation WHERE post_id = p.post_id AND date = "${SelectedDate}")) 
        AND p.type = "Chair rental" 
        AND p.review >= 1 
      GROUP BY p.post_id 
      ORDER BY p.price DESC`,
      [[Chair_rental_val]]
    );
    const result6 = await fetch_data(
      `SELECT p.*, COUNT(res.post_id) AS reservation_count 
      FROM posts p 
      LEFT JOIN reservation res ON p.post_id = res.post_id AND res.date = "${SelectedDate}" 
      WHERE p.price <= ? 
        AND (res.date IS NULL OR p.MaxReservation > (SELECT COUNT(*) FROM reservation WHERE post_id = p.post_id AND date = "${SelectedDate}")) 
        AND p.type = "Stage rental" 
        AND p.review >= 1 
      GROUP BY p.post_id 
      ORDER BY p.price DESC`,
      [[Stage_rental_val]]
    );
    const result7 = await fetch_data(
      `SELECT p.*, COUNT(res.post_id) AS reservation_count 
      FROM posts p 
      LEFT JOIN reservation res ON p.post_id = res.post_id AND res.date =


"${SelectedDate}" 
      WHERE p.price <= ? 
        AND (res.date IS NULL OR p.MaxReservation > (SELECT COUNT(*) FROM reservation WHERE post_id = p.post_id AND date = "${SelectedDate}")) 
        AND p.type = "Restaurant" 
        AND p.review >= 1 
      GROUP BY p.post_id 
      ORDER BY p.price DESC`,
      [[Restaurant_val]]
    );
    const result8 = await fetch_data(
      `SELECT p.*, COUNT(res.post_id) AS reservation_count 
      FROM posts p 
      LEFT JOIN reservation res ON p.post_id = res.post_id AND res.date = "${SelectedDate}" 
      WHERE p.price <= ? 
        AND (res.date IS NULL OR p.MaxReservation > (SELECT COUNT(*) FROM reservation WHERE post_id = p.post_id AND date = "${SelectedDate}")) 
        AND p.type = "Organizer" 
        AND p.review >= 1 
      GROUP BY p.post_id 
      ORDER BY p.price DESC`,
      [[Organizer_val]]
    );
    console.log(result2);

    let final_result = {
      data: {
        photo: result2,
        DJ_OR_Signer: result3,
        Decorating: result4,
        Chair_rental: result5,
        Stage_rental: result6,
        Restaurant: result7,
        Organizer: result8,
      },
    };

    res.status(200).json({
      message: "the operation complete",
      success: true,
      data: final_result,
    });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ message: `internal server error + ${error}`, success: false });
  }
});
//
router.route("/getBusinessCard").get((req, res) => {
  const { id } = req.query;
  if (!id) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT card FROM business WHERE id =?";

  db.query(sql, [id], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      console.log(data[0]["card"]);
      if (data[0]["card"] > 0) {
        var sql2 = "SELECT Cnumber FROM card WHERE id =?";
        db.query(sql2, [data[0]["card"]], function (err, data, fields) {
          if (err) {
            res.send(JSON.stringify({ success: false, message: err }));
          } else {
            res.status(200).send(JSON.stringify({ success: true, data: data }));
          }
        });
      } else {
        res
          .status(200)
          .send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/getUsersCard").get((req, res) => {
  const { id } = req.query;
  if (!id) {
    return res
      .status(400)
      .json({ success: false, message: "Invalid input data." });
  }

  var sql = "SELECT email FROM business WHERE id =?";

  db.query(sql, [id], function (err, data, fields) {
    if (err) {
      res.send(JSON.stringify({ success: false, message: err }));
    } else {
      if (data[0]["email"] != "") {
        var sql2 = "SELECT Cnumber FROM card WHERE Uemail =?";
        db.query(sql2, [data[0]["email"]], function (err, data, fields) {
          if (err) {
            res.send(JSON.stringify({ success: false, message: err }));
          } else {
            res.status(200).send(JSON.stringify({ success: true, data: data }));
          }
        });
      } else {
        res
          .status(200)
          .send(JSON.stringify({ success: false, message: "Empty Data" }));
      }
    }
  });
});
//
router.route("/setBusinessCard").post(async (req, res) => {
  const { id, card } = req.body;

  if (!id || !card) {
    return res
      .status(400)
      .json({ success: false, message: "Input Field is required" });
  }

  let sql = "SELECT id FROM card WHERE Cnumber = ?";
  db.query(sql, [card], function (err, data, result) {
    if (err) {
      return res.json({
        success: false,
        message: err,
      });
    } else {
      if (data[0]["id"] != 0) {
        let sql2 = "UPDATE business SET card = ? WHERE id = ?";
        db.query(sql2, [data[0]["id"], id], function (err, data, result) {
          if (err) {
            return res.json({
              success: false,
              message: err,
            });
          } else {
            return res.json({
              success: true,
            });
          }
        });
      } else {
        return res.json({
          success: false,
          message: "No card to add",
        });
      }
    }
  });
});
module.exports = router;
