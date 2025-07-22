const express = require("express");
const { getStats } = require("../controllers/dashboard");

const router = express.Router();

router.get("/api/dashboard", getStats);

module.exports = router;
