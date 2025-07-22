const express = require("express");
const { login, register } = require("../controllers/auth");

const router = express.Router();

//APIs
router.post("/api/login", login);
router.post("/api/register", register);

module.exports = router;
