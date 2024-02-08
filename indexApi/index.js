const express = require("express");
const cors = require("cors");
const app = express();
const path = require("path");
var bodyParser = require("body-parser");

app.use(cors());
app.use(express.json());
app.use(bodyParser.json({ limit: "50mb" }));
app.use(
  bodyParser.urlencoded({
    limit: "50mb",
    extended: true,
    parameterLimit: 50000,
  })
);

app.use(express.json({ limit: "50mb" }));
app.use(express.urlencoded({ limit: "50mb", extended: true }));

const uploadDirectory = path.join(__dirname, "uploads");
app.use("/images", express.static(uploadDirectory));

const postsFolder = path.join(__dirname, "PostsMainImg");
app.use("/mainImg", express.static(postsFolder));

const subImgFolder = path.join(__dirname, "subImgFolder");
app.use("/subImg", express.static(subImgFolder));

const audios = path.join(__dirname, "Audios");
app.use("/song", express.static(audios));

const songImage = path.join(__dirname, "songImage");
app.use("/songImg", express.static(songImage));

const userRouter = require("./user");
app.use("/user", userRouter);

const adminRouter = require("./admin");
app.use("/admin", adminRouter);

app.listen(3000, () => console.log("your server is running on port 3000"));
