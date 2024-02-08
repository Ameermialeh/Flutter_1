const express = require("express");
var mysql = require("mysql");

var connection = mysql.createConnection({
  host: "127.0.0.1",
  user: "root",
  password: "",
  port: "3306",
  database: "gp1",
});

connection.connect(function (err) {
  if (err) throw err;
  console.log("db connected");
});

module.exports = connection;
